#!/bin/env python

import fileinput
import sqlite3
conn = sqlite3.connect('timestamps.db')

c = conn.cursor()

create_table = '''CREATE TABLE IF NOT EXISTS timestamps (
component TEXT,
start_command INTEGER,
start_in_command INTEGER,
start_work INTEGER,
end_work INTEGER,
end_in_command INTEGER,
end_command INTEGER
)'''
c.execute(create_table)

insertsql = '''
INSERT INTO timestamps VALUES (
:component,
:start_command,
:start_in_command,
:start_work,
:end_work,
:end_in_command,
:end_command
)'''

data = {'start_command': None,
        'start_in_command': None,
        'start_work': None,
        'end_work': None,
        'end_in_command': None,
        'end_command': None
        }
for line in fileinput.input():
  try:
    columns = line.split(' ')
    (head, component, cap, step, timestamp) = columns
  except ValueError as e:
    print e
    break
  print (head, component, cap, step, timestamp)
  if head != 'Timestamp':
    break
  step = step.strip(':')
  timestamp = int(timestamp)
  if cap is u'start' and step is u'command' and data['end_command'] != None:
    print repr(data)
    c.execute(insertsql, data)
    data = {'start_command': None,
            'start_in_command': None,
            'start_work': None,
            'end_work': None,
            'end_in_command': None,
            'end_command': None
            }
  data[u'component'] = component
  data[cap + '_' + step] = timestamp
  print repr(data)


print repr(data)
c.execute(insertsql, data)
conn.commit()
conn.close()