CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR(5)   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "sex" VARCHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" money   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(5)   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR(10)   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "emp_no" INT   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;


--1. List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT employees.emp_no,employees.last_name,employees.first_name, employees.sex, salaries.salary
from employees join salaries on employees.emp_no = salaries.emp_no;

--2. List first name, last name, and hire date for employees who were hired in 1986
SELECT first_name,last_name,hire_date
FROM employees
WHERE hire_date between '1986-01-01' and '1987-01-01';

--3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT departments.dept_no,departments.dept_name,employees.emp_no,employees.last_name,employees.first_name
FROM dept_emp 
LEFT JOIN employees on dept_emp.emp_no = employees.emp_no
LEFT JOIN departments on dept_emp.dept_no = departments.dept_no
WHERE employees.emp_title_id like 'm%';

--4. List the department of each employee with the following information: employee number, last name, first name, and department name.
--METHOD 1
SELECT departments.dept_no,employees.emp_no,employees.last_name,employees.first_name,departments.dept_name
FROM dept_emp 
LEFT JOIN employees on dept_emp.emp_no = employees.emp_no
LEFT JOIN departments on dept_emp.dept_no = departments.dept_no
ORDER BY departments.dept_no;

--METHOD 2
CREATE VIEW all_dept_emp AS -- Create view for the joined table

			(SELECT employees.emp_no
			 		,employees.emp_title_id
			 		,employees.birth_date
			 		,employees.last_name
			 		,employees.first_name
			 		,employees.sex
			 		,employees.hire_date
			 		,departments.dept_name
			 		,departments.dept_no

			FROM 	dept_emp 
					LEFT JOIN employees 
								ON dept_emp.emp_no = employees.emp_no
					LEFT JOIN departments 
								ON dept_emp.dept_no = departments.dept_no)
;

SELECT
		emp_no
		,last_name
		,first_name
		,dept_name
FROM 	all_dept_emp
;

--5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT employees.first_name,employees.last_name,employees.sex 
FROM employees
WHERE employees.first_name ='Hercules' and employees.last_name like 'B%';

--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
CREATE VIEW department_employees AS
(SELECT departments.dept_no,departments.dept_name,employees.emp_no,employees.last_name,employees.first_name
FROM dept_emp 
LEFT JOIN employees on dept_emp.emp_no = employees.emp_no
LEFT JOIN departments on dept_emp.dept_no = departments.dept_no);

SELECT * FROM department_employees 
WHERE department_employees.dept_no='d007';

--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT * FROM department_employees 
WHERE department_employees.dept_name in ('Sales','Development')
ORDER BY department_employees.dept_name;

SELECT * FROM employees;
--8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT employees.last_name,COUNT (employees.last_name) AS frequency
FROM employees
GROUP BY employees.last_name
ORDER BY frequency DESC;
