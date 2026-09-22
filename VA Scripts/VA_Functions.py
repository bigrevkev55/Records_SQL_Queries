import xlsxwriter as x

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
def update():
   '''The function clears the form.  No arguments are required'''
   print('Create this Function') 

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
    print('Create this Function')

def delete():
    print('Create this Function')

def clear():
    '''The function clears the form.  No arguments are required'''
    print('Create this Function')

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
