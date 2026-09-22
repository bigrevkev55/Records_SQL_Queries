#@title
'''
    Author:  Kevin Thomas
      Date:  27-DEC-2020
   Purpose:  This script gives your machine's specifications.  

'''

from platform import python_version, processor, machine, node, system

version = python_version()   
print(f'{version} is your version of python')

system = system()
print(f'{system} is your Operating System')

machine = machine()
print(f'{machine} is your machine type')

processor = processor()
print(f'{processor} is your processor')

network_name = node()
print(f"{network_name} is your computer's network name")