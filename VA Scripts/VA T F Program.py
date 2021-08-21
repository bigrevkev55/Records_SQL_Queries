
def RODP():
  if TN_eCamp==0:
    VA_Request()
  else:
    rodp_cost_hour=171 #per hour; no max
    rodp_online_fee=68 #per hour; no max
    hours_cost=rodp_cost_hour*TN_eCamp
    fees_cost=rodp_online_fee*TN_eCamp
    TN_ecamp=hours_cost+fees_cost
    print(f'RODP T/F is {TN_ecamp}.')
    VA_Request()
    #x=VA_Request()
    #print(type(x))
    #print(f'NSCC charge is {x}')
    #submit=y+TN_ecamp
    #print(f'Submit {submit} to the VA')

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
  return(total_requst)
  
hours=int(input('How many NSCC hours is the student taking? '))
TN_eCamp=int(input('How many TN eCampus hours is the student taking?  '))
RODP()

print(f'The NSCC T/F is {VA_Request()}')

  