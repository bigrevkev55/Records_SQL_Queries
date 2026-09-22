import tkinter as Tk
from tkinter import *
import PIL
from PIL import ImageTk, Image
import PyInstaller
from VA_Functions import *
import tkinter.messagebox


#from VA_GUI import delete, get_student_info, RODP, VA_Request, submit, clear, create_student_wkbk_and_wksht
def onClick():
    tkinter.messagebox.showinfo("Welcome to GFG.",  "Hi I'm your message")

root = Tk()
root.title=("NSCC Veterans Services")
root.iconbitmap=('va_logo.ico')
root.geometry=('800x1000')

# Create Panels
mainPanel=PanedWindow(root,orient='horizontal', bd=2, bg='blue', border=10)
mainPanel.pack()

campusPanel=PanedWindow(mainPanel, orient="vertical", bd=4,background='red', border=15)
campusPanel.pack()

TFPanel=PanedWindow(mainPanel,orient='vertical')
campusPanel.pack()

controlPanel=PanedWindow(mainPanel,orient='horizontal', bd=4,background='red', border=15)
controlPanel.pack()

# Create the Frames
wbr_frame = LabelFrame(mainPanel,text='WBR')
wbr_frame.pack()
campusPanel.add(wbr_frame)

camp2_frame = LabelFrame(mainPanel, text='Clarksville')
camp2_frame.pack()
campusPanel.add(camp2_frame)

camp3_frame = LabelFrame(mainPanel, text='Southeast/Antioch')
camp3_frame.pack()
campusPanel.add(camp3_frame)

camp4_frame = LabelFrame(mainPanel, text='Dickson')
camp4_frame.pack()
campusPanel.add(camp4_frame)

camp5_frame = LabelFrame(mainPanel, text='Waverly')
camp5_frame.pack()
campusPanel.add(camp5_frame)

camp6_frame = LabelFrame(mainPanel, text='North Davidson')
camp6_frame.pack()
campusPanel.add(camp6_frame)

camp7_frame = LabelFrame(mainPanel, text='East Davidson')
camp7_frame.pack()
campusPanel.add(camp7_frame)

rodp_frame = LabelFrame(mainPanel, text='TN eCampus')
rodp_frame.pack()
campusPanel.add(rodp_frame)

totals_frame = LabelFrame(root)
totals_frame.pack()
TFPanel.add(totals_frame)

buttons_frame = LabelFrame(controlPanel, text='Controls')
buttons_frame.pack()
controlPanel.add(buttons_frame)


# Create and pack the widgets for Campus1
campus1ResEntry = Entry(wbr_frame, fg='gray')
campus1ResEntry.pack(side='left')
campus1ResEntry.insert(0,'WBR Res Hours')

campus1Dis = Entry(wbr_frame, fg='gray')
campus1Dis.pack(side='left')
campus1Dis.insert(0,'WBR Dis Hours')

campus1RD= Entry(wbr_frame,fg='gray')
campus1RD.pack(side='left')
campus1RD.insert(0,'WBR R\D Hours')

campus1Clock= Entry(wbr_frame,fg='gray')
campus1Clock.pack(side='left')
campus1Clock.insert(0,'WBR Clock Hours')

campus1TF= Entry(wbr_frame,fg='gray')
campus1TF.pack(side='left')
campus1TF.insert(0,'T/F to request from VA')


# Create and pack the widgets for Campus2
campus2ResEntry = Entry(camp2_frame, fg='gray')
campus2ResEntry.pack(side='left')
campus2ResEntry.insert(0,'Clarksville Res Hours')

campus2DisEntry = Entry(camp2_frame, fg='gray')
campus2DisEntry.pack(side='left')
campus2DisEntry.insert(0,'Clarksville Dis Hours')

campus2RD = Entry(camp2_frame, fg='gray')
campus2RD.pack(side='left')
campus2RD.insert(0,'Clarksville RD Hours')

campus2ClockEntry = Entry(camp2_frame, fg='gray')
campus2ClockEntry.pack(side='left')
campus2ClockEntry.insert(0,'Clarksville Clock Hours')

campus2TF = Entry(camp2_frame, fg='gray')
campus2TF.pack(side='left')
campus2TF.insert(0,'T/F to Request from VA')


# Create and pack the widgets for Campus3
campus3ResEntry = Entry(camp3_frame, fg='gray')
campus3ResEntry.pack(side='left')
campus3ResEntry.insert(0,'Southeast Res Hours')

campus3DisEntry = Entry(camp3_frame, fg='gray')
campus3DisEntry.pack(side='left')
campus3DisEntry.insert(0,'Southeast Dis Hours')

campus3RD = Entry(camp3_frame, fg='gray')
campus3RD.pack(side='left')
campus3RD.insert(0,'Southeast RD Hours')

campus3ClockEntry = Entry(camp3_frame, fg='gray')
campus3ClockEntry.pack(side='left')
campus3ClockEntry.insert(0,'Southeast Clock Hours')

campus3TF = Entry(camp3_frame, fg='gray')
campus3TF.pack(side='left')
campus3TF.insert(0,'T/F to Request from VA')



# Create and pack the widgets for Campus4
campus4ResEntry = Entry(camp4_frame, fg='gray')
campus4ResEntry.pack(side='left')
campus4ResEntry.insert(0,'Dickson Res Hours')

campus4DisEntry = Entry(camp4_frame, fg='gray')
campus4DisEntry.pack(side='left')
campus4DisEntry.insert(0,'Dickson Dis Hours')

campus4RD = Entry(camp4_frame, fg='gray')
campus4RD.pack(side='left')
campus4RD.insert(0,'Dickson RD Hours')

campus4ClockEntry = Entry(camp4_frame, fg='gray')
campus4ClockEntry.pack(side='left')
campus4ClockEntry.insert(0,'Dickson Clock Hours')

campus4TF = Entry(camp4_frame, fg='gray')
campus4TF.pack(side='left')
campus4TF.insert(0,'T/F to Request from VA')



# Create and pack the widgets for Campus5
campus5ResEntry = Entry(camp5_frame, fg='gray')
campus5ResEntry.pack(side='left')
campus5ResEntry.insert(0,'Waverly Res Hours')

campus5DisEntry = Entry(camp5_frame, fg='gray')
campus5DisEntry.pack(side='left')
campus5DisEntry.insert(0,'Waverly Dis Hours')

campus5RD = Entry(camp5_frame, fg='gray')
campus5RD.pack(side='left')
campus5RD.insert(0,'Waverly RD Hours')

campus5ClockEntry = Entry(camp5_frame, fg='gray')
campus5ClockEntry.pack(side='left')
campus5ClockEntry.insert(0,'Waverly Clock Hours')

campus5TF = Entry(camp5_frame, fg='gray')
campus5TF.pack(side='left')
campus5TF.insert(0,'T/F to Request from VA')


# Create and pack the widgets for Campus6
campus6ResEntry = Entry(camp6_frame, fg='gray')
campus6ResEntry.pack(side='left')
campus6ResEntry.insert(0,'North Davidson Res Hours')

campus6DisEntry = Entry(camp6_frame, fg='gray')
campus6DisEntry.pack(side='left')
campus6DisEntry.insert(0,'North Davidson Dis Hours')

campus6RD = Entry(camp6_frame, fg='gray')
campus6RD.pack(side='left')
campus6RD.insert(0,'North Davidson RD Hours')

campus6ClockEntry = Entry(camp6_frame, fg='gray')
campus6ClockEntry.pack(side='left')
campus6ClockEntry.insert(0,'North Davidson Clock Hours')

campus6TF = Entry(camp6_frame, fg='gray')
campus6TF.pack(side='left')
campus6TF.insert(0,'T/F to Request from VA')



# Create and pack the widgets for Campus7
campus7ResEntry = Entry(camp7_frame, fg='gray')
campus7ResEntry.pack(side='left')
campus7ResEntry.insert(0,'East Davidson Res Hours')

campus7DisEntry = Entry(camp7_frame, fg='gray')
campus7DisEntry.pack(side='left')
campus7DisEntry.insert(0,'East Davidson Dis Hours')

campus7RD = Entry(camp7_frame, fg='gray')
campus7RD.pack(side='left')
campus7RD.insert(0,'East Davidson RD Hours')

campus7ClockEntry = Entry(camp7_frame, fg='gray')
campus7ClockEntry.pack(side='left')
campus7ClockEntry.insert(0,'East Davidson Clock Hours')

campus7TF = Entry(camp7_frame, fg='gray')
campus7TF.pack(side='left')
campus7TF.insert(0,'T/F to Request from VA')


# Create and pack widtets for TN eCampus
RODPResEntry = Entry(rodp_frame, state='readonly', background='black' )
RODPResEntry.pack(side='left')
RODPResEntry.insert(0,'RODP Res Hours')

RODPDisEntry = Entry(rodp_frame, fg='gray')
RODPDisEntry.pack(side='left')
RODPDisEntry.insert(0,'RODP Dis Hours')

RODPRD = Entry(rodp_frame, fg='gray', state='disabled')
RODPRD.pack(side='left')
RODPRD.insert(0,'RODP RD Hours')

RODPClockEntry = Entry(rodp_frame, fg='gray', state='disabled')
RODPClockEntry.pack(side='left')
RODPClockEntry.insert(0,'RODP Clock Hours')

RODPTF = Entry(rodp_frame, fg='gray')
RODPTF.pack(side='left')
RODPTF.insert(0,'T/F to Request from VA')

#Create and pack the control buttons
submit_btn = Button(buttons_frame,command=clear, text='Clear')
submit_btn.pack(side='left')

delete_btn = Button(buttons_frame,command=delete, text='Delete')
delete_btn.pack(side='left')

update_btn = Button(buttons_frame, text='Update Selected Record', command=update)
update_btn.pack(side='left')

root.mainloop()
