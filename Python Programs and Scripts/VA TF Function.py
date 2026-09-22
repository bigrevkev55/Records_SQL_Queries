

#Author: Kevin Thomas, Registrar
#Date:  14-JUL-2022
#Purpose:  This program can be used to help VA SCOs know how much T/F to request from students
#Note:  !!!!! VIP.....This program has not been throughly tested.  Use with caution !!!!!!!!!


from ast import Pass


def vatf():        
    mainfee=input('\nEnter main fees: $')
    taffee1=input('Enter first TAF fees: $')
    taffee2=input('Enter second TAF fees, if any: $')
    additionafees=18
    additionafees=int(additionafees)
    mainfee=int(mainfee)
    taffee1=int(taffee1)
    taffee2=int(taffee2)
    taffee=taffee1+taffee2
    submit=mainfee+taffee+additionafees
    message=print(f'Request ${submit} from the VA for this student')
    return(message)

def vatfr():
    rodpmainfee=input('Enter RODP main fee: $')
    rodponlinefee=input('Enter RODP online fee: $')
    rodpmainfee=int(rodpmainfee)
    rodponlinefee=int(rodponlinefee)
    rodpcharges=rodpmainfee+rodponlinefee
    inputq = input('Does the student have NSCC courses too? (y for yes, any key for no):  ')
    inputq = inputq.upper()
    
    if inputq == 'Y':
            additionafees=18
            mainfee=input('\nEnter NSCC main fees: $')
            taffee1=input('Enter first TAF fees: $')
            taffee2=input('Enter second TAF fees, if any: $')
            mainfee=int(mainfee)
            taffee1=int(taffee1)
            taffee2=int(taffee2)
            taffee=taffee1+taffee2
            nsccfee=mainfee+taffee+additionafees
            submit=nsccfee+rodpcharges
            message=print(f'Request ${submit} from the VA for this student')
            return(message)
            
    else:
        message=print(f'Request ${rodpcharges} from the VA for this student')
        return(message)

while True:

       print('\nWelcome to the VA T/F Tool.  This tool only works with summer T/F at the present time.')
       question = input('\n Does the student have TN eCampus courses (Y for yes, any key for no): ')
       question = question.upper()
       
       if question == 'Y':
           vatfr()
       else:
            vatf()
            
continueq=input('Would you like to submit another student?:  ')
continueq=continueq.upper()

if continueq == 'Y':
    True

else:
    False

print('\n Have a great day!!! Bye!!! ')
                    


        

   
