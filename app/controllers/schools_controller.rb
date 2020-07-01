class SchoolsController < ApplicationController
  def index
  end

  def students
    @students_all = Student.all()
  end

  def teachers
    @teachers_all = Teacher.all()
  end

  def subjects
    @subjects_all = Subject.all()
  end

  def student_edit
    id = params[:id]
    @student = Student.find_by(id: id)
  end

  def teacher_edit
    id = params[:id]
    puts "teacher ID = #{id}"
    @teacher = Teacher.find_by(id: id)
  end

  def subject_edit
    id = params[:id]
    puts "subject ID = #{id}"
    @subject = Subject.find_by(id: id)
  end

  def student_update
    new_name = params[:student][:name]
    id = params[:student][:id]
    puts "student updated name = #{new_name}"
    user = Student.find_by(id: id)
    user.update(name: new_name)
    # CHECK IF SAVE WAS SUCCESFUL
    redirect_to schools_students_path
  end

  def teacher_update
    new_name = params[:teacher][:name]
    id = params[:teacher][:id]
    puts "teacher updated name = #{new_name}"
    user = Teacher.find_by(id: id)
    user.update(name: new_name)
    # CHECK IF SAVE WAS SUCCESFUL
    redirect_to schools_teachers_path
  end

  def subject_update
    id = params[:id]
    new_name = params[:subject][:name]
    student_id = params[:subject][:student_id]
    teacher_id = params[:subject][:teacher_id]
    new_student = Student.find_by(id: student_id)
    new_teacher = Teacher.find_by(id: teacher_id)
    puts "subject updated name = #{new_name}"
    subject = Subject.find_by(id: id)
    
    if subject.update(name: new_name, student: new_student, teacher: new_teacher)
      redirect_to schools_subjects_path
    end
  end

  def student_new
  end

  def teacher_new
  end

  def subject_new
  end

  def student_create
    name = params[:name]
    puts "new student = #{name}"
    # Student.create(name: name)
    new_student = Student.new(name: name)

    if new_student.save
      redirect_to schools_students_path
    else
      render 'student_create'
    end

  end

  def teacher_create
    name = params[:name]
    puts "new teacher = #{name}"
    # Teacher.create(name: name)
    new_teacher = Teacher.new(name: name)

    if new_teacher.save
      redirect_to schools_teachers_path
    else
      render 'teacher_create'
    end

  end

  def subject_create
    name = params[:name]
    student_id = params[:student_id]
    teacher_id = params[:teacher_id]
    student = Student.find_by(id: student_id)
    teacher = Teacher.find_by(id: teacher_id)
    # puts "new subject = #{name}, student = #{student}, teacher = #{teacher}"
    new_subject = Subject.new(name: name, student: student, teacher: teacher)

    if new_subject.save
      redirect_to schools_subjects_path
    else
      render 'subject_create'
    end

  end

  def student_destroy
    id = params[:id]
    student = Student.find_by(id: id)
    
    if student.destroy
      redirect_to schools_students_path
    end

  end

  def teacher_destroy
    id = params[:id]
    teacher = Teacher.find_by(id: id)
    
    if teacher.destroy
      redirect_to schools_teachers_path
    end
  end

  def subject_destroy
    id = params[:id]
    subject = Subject.find_by(id: id)
    
    if subject.destroy
      redirect_to schools_subjects_path
    end
  end

  private

  
end
