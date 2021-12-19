# The student class holds data about a student.

class Student:
    '''The student class stores data information about students'''

    def __init__(self, id, ch, last, first, camp, res, dis, rd, clock, tf):
        self.__chapter = ch
        self.__Anumber = id
        self.__lname = last
        self.__fname = first
        self.__campus = camp
        self.__residential = res
        self.__distance = dis
        self.__remedial = rd
        self.__clockhours = clock
        self.__tuition = tf

    def set_id(self, id):
        self.__id = id

    def get_id(self):
        return self.__id

    def set_ch(self, ch):
        self.__ch = ch

    def get_ch(self):
        return self.__ch

    def set_last(self, last):
        self.__last = last

    def get_last(self):
        return self.__last

    def set_first(self, first):
        self.__first = first

    def get_first(self):
        return self.__first

    def set_camp(self, camp):
        self.__camp = camp

    def get_camp(self):
        return self.__camp

    def set_res(self, res):
        self.__res = res

    def get_res(self):
        return self.__res

    def set_dis(self, dis):
        self.__dis = dis

    def get_dis(self):
        return self.__dis

    def set_rd(self, rd):
        self.__rd = rd

    def get_rd(self):
        return self.__rd

    def set_clock(self, clock):
        self.__clock = clock

    def get_clock(self):
        return self.__clock

    def set_tf(self, tf):
        self.__tf = tf

    def get_tf(self):
        return self.__tf

    def get_student_info(self):
        return 'Your students are'+' '+self.__Anumber+':'+self.__lname+','+self.__fname

    def __str__(self):
        return('Request the following from the VA...'+self.__Anumber + ' ' + self.__chapter + ':'+self.__lname+','+self.__fname+','+self.__campus+','+self.__residential+','+self.__distance+','+self.__remedial+','+self.__clockhours+','+self.__tuition+'.')
