
def RODP():
  if TN_eCamp==0:
    VA_Request()
  else:
    print('bulid TN eCamp func')

def VA_Request():
  cost_hour=199 #1-12; 37 for each over 12
  tech_fee=10 #per hour, $116 max
  camp_fee=15
  sga_fee=1
  activity_fee=2  
  base=int(cost_hour*hours)
  tech_total=int(tech_fee*hours)
  fee_total=int(tech_total+sga_fee+activity_fee)
  total_requst=int(base+fee_total)
  print(total_requst)
  
hours=int(input('How many NSCC hours is the student taking? '))
TN_eCamp=int(input('How many TN eCampus hours is the student taking?  '))
RODP()
  