#!/bin/env python

description = """Converts stderr log from instrumented components into a sqlite table.

Log format is 'Timestamp [component] [cap] [step]: [timestamp]' where:
* component, name of component
* cap, start or end
* step, name of step inside component, all steps must be defined in metrics variable below
* timestamp, current time in milliseconds
Example 'Timestamp EHU-tok start command: 1409668228760'

Run component with:

    for x in `ls testset/*xml` do
    basename $x
    cat $x | ~/components/EHU-tok/run.sh > output/`basename $x`.EHU-tok 2>> EHU-tok.log
    done

Or all of them after each other:

   for x in `ls testset/*xml`; do basename $x; cat $x | ~/components/EHU-tok/run.sh > output/`basename $x`.EHU-tok 2>> EHU-tok.log; done
   for x in `ls output/*tok`; do basename $x; cat $x | ~/components/EHU-pos/run.sh > output/`basename $x`.EHU-pos 2>> EHU-pos.log; done
   for x in `ls output/*pos`; do basename $x; cat $x | ~/components/VUA-multiwordtagger/run.sh > output/`basename $x`.VUA-mw 2>> VUA-mw.log; done
   for x in `ls output/*mw`; do basename $x; cat $x | ~/components/EHU-nerc/run.sh > output/`basename $x`.EHU-nerc 2>> EHU-nerc.log; done
   for x in `ls output/*nerc`; do basename $x; cat $x | timeout 60 ~/components/VUA-opinion-miner/run.sh > output/`basename $x`.VUA-om 2>> VUA-om.log; done
   for x in `ls output/*om`; do basename $x; cat $x | ~/components/VUA-svm-wsd/run.sh > output/`basename $x`.VUA-wsd 2>> VUA-wsd.log; done
   #start dbpedia server
   for x in `ls output/*wsd`; do basename $x; cat $x | ~/components/EHU-ned/run.sh > output/`basename $x`.EHU-ned 2>> EHU-ned.log; done
   #stop dbpedia server
   for x in `ls output/*ned`; do basename $x; cat $x | ~/components/EHU-srl/run.sh > output/`basename $x`.EHU-srl 2>> EHU-srl.log; done
   for x in `ls output/*srl`; do basename $x; cat $x | ~/components/FBK-time/run.sh > output/`basename $x`.FBK-time 2>> FBK-time.log; done
   for x in `ls output/*time`; do basename $x; cat $x | ~/components/VUA-eventcoref/run.sh > output/`basename $x`.VUA-ecoref 2>> VUA-ecoref.log; done
   for x in `ls output/*ecoref`; do basename $x; cat $x | ~/components/VUA-factuality/run.sh > output/`basename $x`.VUA-fact 2>> VUA-fact.log; done

Convert log 2 db with:

    python log2db.py < EHU-tok.log

Creates a sqlite db called timestamps.db with the following tables:
* timestamps, start/end (in milliseconds since epoch) of steps in a component
* intervals, duration (in milliseconds) of each step in a component
* avg_intervals, the average of each step in each component

Fetch csv using:

    sqlite3 -csv -header timestamps.db 'SELECT * FROM avg_intervals' > avg_intervals.csv
    sqlite3 -csv -header timestamps.db 'SELECT * FROM intervals WHERE component' > intervals.csv

"""

import fileinput
import sqlite3
import argparse

parser = argparse.ArgumentParser(description=description,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
parser.add_argument('--database',
                    default='timestamps.db',
                    help='Sqlite database filename (default is timestamps.db)',
                    )
(args, inputs) = parser.parse_known_args()
conn = sqlite3.connect(args.database)
c = conn.cursor()

metrics = set([
               'start_command',
               'start_in_command',
               'start_setup',
               'end_setup',
               'start_work',
               'end_work',
               'end_in_command',
               'end_command',
               ])

create_table = 'CREATE TABLE IF NOT EXISTS timestamps (component TEXT,'
create_table += ','.join([metric + ' INTEGER' for metric in metrics])
create_table += ')'
c.execute(create_table)

interval_view = '''CREATE VIEW IF NOT EXISTS intervals AS
SELECT
component
,start_command start
,(end_command - start_command) wall
,(start_in_command - start_command) start_executable
,(end_setup - start_setup) setup
,(start_work - start_in_command - (end_setup - start_setup)) kaf2native
,(start_work - start_in_command) setup_kaf2native
,(end_work - start_work) core
,(end_in_command - end_work) native2kaf_teardown
,(end_command - end_in_command) stop_executable
FROM timestamps
'''
c.execute(interval_view)

avg_interval_view = '''CREATE VIEW IF NOT EXISTS avg_intervals AS
SELECT
component
,count(*) nr_docs
,avg(wall)
,avg(start_executable)
,avg(setup_kaf2native)
,avg(setup)
,avg(kaf2native)
,avg(core)
,avg(native2kaf_teardown)
,avg(stop_executable)
FROM intervals
GROUP BY component
'''
c.execute(avg_interval_view)

conn.commit()
insertsql = 'INSERT INTO timestamps VALUES (:component,'
insertsql += ','.join([':' + metric for metric in metrics])
insertsql += ')'

data = {}
for metric in metrics:
  data[metric] = None

for line in fileinput.input(inputs):
    columns = line.split(' ')
    if len(columns) != 5:
        continue
    try:
        (head, component, cap, step, timestamp) = columns
    except ValueError as e:
        print e
        break
    if head != 'Timestamp':
        continue
    step = step.strip(':')
    step = step.replace('-', '_')
    column = cap + '_' + step
    if column not in metrics:
        print 'Invalid metric: ' + column
        continue
    timestamp = int(timestamp)
    if column == 'start_command' and data['end_command'] != None:
        c.execute(insertsql, data)
        data = {}
        for metric in metrics:
            data[metric] = None
    data[u'component'] = component
    data[column] = timestamp

c.execute(insertsql, data)
conn.commit()
conn.close()
