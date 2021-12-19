from student import Student
import pandas as pd

FILENAME = 'students.xlxs'


def main():
    students = []
    keep_going = True
    output_file = open(FILENAME, 'w')

    while keep_going == True:
        anumber = input('Enter the students A Number:  ')
        chapter = input('Enter the students chapter: ')
        lname = input('Enter the student\'s last name: ')
        first = input('Enter first name: ')
        camp = input('Enter campus: ')
        res = input('Enter res: ')
        dis = input('Enter distance: ')
        rd = input('Enter r/d: ')
        clock = input('Enter clock hours: ')
        tf = input('Enter t/f: ')

       # create instance of the Student class
        student = Student(anumber, chapter, lname, first,
                          camp, res, dis, rd, clock, tf)

       # Add created object/instanct to the students list above
        students.append(student)

        # Add prompt to ask if use wants to continue
        question = input(
            'To enter another student press "y"; press any other key to stop entering students: ')
        if question.lower() == 'y':
            keep_going = True
        else:
            keep_going = False
    else:
        studentsdf = pd.DataFrame(students)
        print(studentsdf)

        #print(f'\n The data was written to {FILENAME}')
main()
print('Goodbye...')
