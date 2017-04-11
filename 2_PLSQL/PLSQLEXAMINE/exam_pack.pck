create or replace package exam_pack is
--2.������������
	TYPE MSTUD IS RECORD(
		STUDENT_NO     HAND_STUDENT.STUDENT_NO%TYPE,
		STUDENT_NAME   HAND_STUDENT.STUDENT_NAME%TYPE,
		STUDENT_AGE    HAND_STUDENT.STUDENT_AGE%TYPE,
		STUDENT_GENDER HAND_STUDENT.STUDENT_GENDER%TYPE,
		COURSE_NO      HAND_COURSE.COURSE_NO%TYPE,
		COURSE_NAME    HAND_COURSE.COURSE_NAME%TYPE,
		TEACHER_NAME   HAND_TEACHER.TEACHER_NAME%TYPE,
		CORE           HAND_STUDENT_CORE.CORE%TYPE,
		AVG_CORE       NUMBER,
		MAX_CORE       NUMBER,
		MIN_CORE       NUMBER);
	--1.�����α���������
	TYPE REF_CURSOR IS REF CURSOR RETURN MSTUD;
	--3.����һ����������������Ϊ ref_cursor��
	--ȡ���������ڿγ�ƽ���ֵ�ѧ����Ϣ��ѧ�š��������γ̱�š��γ�������ʦ���������γ�ƽ���֡��γ���߷֡���ͷ֡���7��)
	FUNCTION AVG_STU(COUR_NO VARCHAR2) RETURN REF_CURSOR;
    --5.����һ�����������ݲ����Ľ�ʦ��ţ����������ʦ��ֱ���쵼�Ľ�ʦ��š�
    --��������ڣ�����-1�� ������ڶ�����¼������-2��������������쳣������-3	SELECT * FROM hand_teacher
    FUNCTION get_manager(man_no VARCHAR2) RETURN NUMBER;

end exam_pack;
/
create or replace package body exam_pack is
--3.����һ����������������Ϊ ref_cursor��
	--ȡ���������ڿγ�ƽ���ֵ�ѧ����Ϣ��ѧ�š��������γ̱�š��γ�������ʦ���������γ�ƽ���֡��γ���߷֡���ͷ֡���7��)
	FUNCTION AVG_STU(COUR_NO VARCHAR2) RETURN REF_CURSOR IS
		STUINFO MSTUD;
		CURSOR STUC IS(
			SELECT STU.STUDENT_NO,
				   STU.STUDENT_NAME,
				   STU.STUDENT_AGE,
				   STU.STUDENT_GENDER,
				   COUR.COURSE_NO,
				   COUR.COURSE_NAME,
				   TEA.TEACHER_NAME,
				   MCORE.CORE
			  FROM HAND_STUDENT      STU,
				   HAND_COURSE       COUR,
				   HAND_TEACHER      TEA,
				   HAND_STUDENT_CORE MCORE
			 WHERE STU.STUDENT_NO = MCORE.STUDENT_NO
			   AND COUR.COURSE_NO = MCORE.COURSE_NO
			   AND COUR.TEACHER_NO = TEA.TEACHER_NO
			   AND MCORE.CORE < (SELECT AVG(CORE)
								   FROM HAND_STUDENT_CORE
								  GROUP BY COURSE_NO
								 HAVING COURSE_NO = COUR_NO));
	BEGIN
		RETURN NULL;
	END AVG_STU;

	--5.����һ�����������ݲ����Ľ�ʦ��ţ����������ʦ��ֱ���쵼�Ľ�ʦ��š�
	--��������ڣ�����-1�� ������ڶ�����¼������-2��������������쳣������-3 SELECT * FROM hand_teacher
	FUNCTION GET_MANAGER(man_no VARCHAR2) RETURN NUMBER IS
		icount NUMBER;
        flag NUMBER;
	BEGIN
		SELECT COUNT(tea.teacher_no) INTO icount FROM hand_teacher man,hand_teacher tea WHERE tea.manager_no=man.teacher_no AND man.teacher_no=man_no;
        IF icount=1 THEN
        	flag:= 1;
        ELSIF icount>1 THEN
        	flag:= -2;
        END IF;
        RETURN flag;
	EXCEPTION
    	WHEN no_data_found THEN
        	RETURN -1;
        WHEN OTHERS THEN
        	RETURN -3;
	END GET_MANAGER;
end exam_pack;
/