import xlsxwriter as x
from tkinter import *
from tkinter import ttk

root = Tk()

#Global Constants
RODP_COST_HOUR=171 #per hour; no max
RODP_ONLINE_FEE=68 #per hour; no max
NSCC_COST_HOUR=171 #1-12; 37 for each over 12
NSCC_OVER_12_CHARGE=37
TECH_FEE=10 #per hour, $116 max
MAX_TECH_FEE=116
CAMP_FEE=15
SGA_FEE=1
ACTIVITY_FEE=2

##Functions

def get_student_info():
      global lname
      lname=input("Enter student's last name:  ")
      global fname
      fname=input("Enter student's first name:  ")
      global Anum
      Anum=input("Enter student's A Number:  ")
      global term
      term=input('Enter term code:  ')

def RODP(TN_eCamp, hours):
  if TN_eCamp==0:
    VA_Request(hours)
  else:
    hours_cost=RODP_COST_HOUR*TN_eCamp
    fees_cost=RODP_ONLINE_FEE*TN_eCamp
    TN_ecamp=hours_cost+fees_cost
    print(f'RODP T/F is {TN_ecamp}.')
    VA_Request(hours)

def VA_Request(hours):
    if hours < 12:
      base=int(NSCC_COST_HOUR*hours)
      tech_fee = TECH_FEE*hours
      totalFees=tech_fee+CAMP_FEE+SGA_FEE+ACTIVITY_FEE
      global total
      total=base+totalFees
      return(total)
    if hours == 12:
          base=NSCC_COST_HOUR*hours
          tech_fee = MAX_TECH_FEE
          totalFees=tech_fee+CAMP_FEE+SGA_FEE+ACTIVITY_FEE
          total=base+totalFees
          return(total)
    if hours >= 12:
          base=(NSCC_COST_HOUR*12)
          hours_over_12 = hours - 12
          over12Charge=hours_over_12*NSCC_OVER_12_CHARGE
          totalFees=MAX_TECH_FEE+CAMP_FEE+SGA_FEE+ACTIVITY_FEE
          total=base+over12Charge+totalFees
          return(total)

def submit():
    myLabel=Label(root, text="Process Completed").grid(row=101, column=0)

def delete():
    myLabel=Label(root, text="Record Deleted").grid(row=101, column=2)

def clear():
    myLabel=Label(root, text="Record Cleared").grid(row=101, column=1)

def create_student_wkbk_and_wksht():
      global outworkbook
      outworkbook=x.Workbook(f'{lname}'+'_'+f'{fname}.xlsx')
      global outsheet
      outsheet=outworkbook.add_worksheet()
      global student_data
      student_data=[term,Anum,lname,fname,campus, hours, total] 
      outsheet.write("A1", "Term")
      outsheet.write("B1", "A Number")
      outsheet.write("C1", "Last")
      outsheet.write("D1", "First")
      outsheet.write("E1", "Campus")
      outsheet.write("F1", "Hours")
      outsheet.write("G1", "T/F")
      outsheet.write("A2", term)
      outsheet.write("B2", Anum)
      outsheet.write("C2", lname)
      outsheet.write("D2", fname)
      outsheet.write("E2", campus)
      outsheet.write("F2", hours)
      outsheet.write('G2', total)
      outworkbook.close()
      print('File created and saved in the VA S Drive')
      print()

#Define Main Function#
def main():
   #Get student information
   get_student_info()
   #Get string of each campus the student attends 
   print()
   campusList = input('Enter each campus code separated by a comma:  ')

   #Convert campusList to a list on the commas, since lists are itterable
   campusCodes=campusList.split(',')

   #Confirm the campuses are correct
   print()
   print(f"The campuse code(s) for this student is (are):  {campusCodes}.")
   print()
   confirmation=input("If the campuses are correct enter 'Y' to continue, any other key to start over:  ").upper()
   print()
   if confirmation=='Y':
        global campus 
        for campus in campusCodes:
            print()
            global hours
            hours=int(input(f'How many NSCC hours is the student taking on {campus}? '))
            if campus == '90M':
                  global TN_eCamp
                  TN_eCamp=int(input(f'How many TN eCampus hours is the student taking on {campus}?  '))
                  if TN_eCamp > 0:
                        RODP(TN_eCamp, hours)
                        print()
                        print(f'The NSCC T/F for {campus} is {VA_Request(hours)}')
                  else:
                        print()
                        print(f'The NSCC T/F for {campus} is {VA_Request(hours)}')
            else:
                  print()
                  print(f'The NSCC T/F for {campus} is {VA_Request(hours)}')
   else:
         main()

rootLabel = Label(root, text="NSCC Veteran Services").grid(row=0, column=1)

submitButton=Button(root, text="Submit", command=submit, fg="white", bg='green', state=ACTIVE).grid(row=100, column=0)
deleteButton=Button(root, text='Delete', command=delete, fg="white", bg='red', state=ACTIVE).grid(row=100, column=2)
clearButton=Button(root, text='Clear', command=clear, state=ACTIVE).grid(row=100, column=1)
postButton=Button(root, text='Click to create and save to S Drive', command=create_student_wkbk_and_wksht).grid(row=100, column=3)
mainButton=Button(root, text='Click to run program', command=main).grid(row=100,column=4)

root.mainloop()

