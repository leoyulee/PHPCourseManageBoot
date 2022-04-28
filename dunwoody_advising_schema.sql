drop schema if exists dunwoody_advising_schema;
create schema dunwoody_advising_schema;
use dunwoody_advising_schema;

create table COMMENT_SET (
    comment_set_id int AUTO_INCREMENT, primary key (comment_set_id)
);

create table USER_TBL (
user_id int AUTO_INCREMENT,
advisor_id int,
first_name varchar(50),
last_name varchar(50),
email varchar(50),
user_password varchar(50),
is_admin boolean,
date_added datetime,
last_modified datetime,
date_deleted datetime,
comment_set_id int,
constraint advisor_id_fk
foreign key (advisor_id) references USER_TBL (user_id),
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key (user_id)
);

create table COMMENT_TBL (
comment_id int primary key,
comment_set_id int,
comment_text text,
user_id int,
date datetime,
database_user int, -- does this need to reference something?  I think we said this was the user that entered the comment?
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
foreign key (user_id) references USER_TBL (user_id)
);


-- insert into USER_TBL (first_name) values ("Anders");
-- select * from user_tbl;

create table PROGRAM_TBL(
program_id int AUTO_INCREMENT,
program_code varchar(10),
program_name varchar(50),
program_description text,
program_credits int,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key (program_id)
);

create table ACADEMIC_PLAN_TBL(
plan_id int AUTO_INCREMENT,
plan_parent_id int,
user_id int,
program_id int,
established_date datetime,
closed_date datetime,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint program_id_fk
foreign key (program_id) references PROGRAM_TBL (program_id),
constraint plan_parent_id_fk
foreign key (plan_parent_id) references ACADEMIC_PLAN_TBL (plan_id),
constraint user_id_fk2
foreign key (user_id) references USER_TBL (user_id),
primary key (plan_id)
);

-- create table PLAN_COMMENT_TBL(
-- comment_id int AUTO_INCREMENT,
-- plan_id int,
-- comment_text text,
-- constraint plan_id_fk5
-- foreign key (plan_id) references ACADEMIC_PLAN_TBL (plan_id),
-- primary key (comment_id)
-- );
create table TERM_TBL(
term_id int AUTO_INCREMENT,
season varchar(15),
class_level varchar(2),
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key (term_id)
);

create table SPECIFIC_TERM_TBL(
spec_term_id int AUTO_INCREMENT,
general_term_id int,
term_year int,
credits int,
date_added datetime,
date_updated datetime,
comment_set_id int,
constraint general_term_id_fk
foreign key (general_term_id) references TERM_TBL(term_id),
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key (spec_term_id)
);

create table ROLE_TBL(
role_id int AUTO_INCREMENT,
role_name varchar(20),
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key(role_id)
);

create table PREREQUISITE_LNK(
prerequisite_id int AUTO_INCREMENT,
start_date date,
end_date date,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key (prerequisite_id)
);
create table COURSE_TBL(
course_id int AUTO_INCREMENT,
term_id int,
course_code varchar(15),
course_description text,
prerequisite_id int,
program_id int,
required boolean,
instruction_type varchar(15),
category varchar(25),
sub_category varchar(25),
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint term_id_fk
foreign key (term_id) references TERM_TBL (term_id),
constraint program_id_fk2
foreign key (program_id) references PROGRAM_TBL (program_id),
constraint prerequisite_id_fk
foreign key (prerequisite_id) references PREREQUISITE_LNK (prerequisite_id),
primary key (course_id)
);

alter table PREREQUISITE_LNK
add column course_id int after prerequisite_id,
add constraint course_id_fk
foreign key (course_id) references COURSE_TBL (course_id),
drop primary key,
add primary key (prerequisite_id,course_id)
-- is this adding or replacing primary key?
-- is there a better way to do this?  seems kludgey
;

create table CLASS_TBL(
class_id int AUTO_INCREMENT,
course_id int,
spec_term_id int,
start_date date,
end_date date,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint course_id_fk3
foreign key (course_id) references COURSE_TBL (course_id),
constraint spec_term_id_fk
foreign key (spec_term_id) references SPECIFIC_TERM_TBL (spec_term_id),
primary key (class_id)
);

create table STATUS_TYPE(
status_id int AUTO_INCREMENT,
status_name varchar(50),
status_desc text,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key (status_id)
);
create table ENROLLMENT_LNK(
class_id int,
user_id int,
status_id int,
enrollment_date date,
completed_date date,
applied_to_plan boolean,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key(class_id, user_id),
constraint class_id_fk
foreign key (class_id) references CLASS_TBL (class_id),
constraint user_id_fk4
foreign key (user_id) references USER_TBL (user_id),
constraint status_id_fk
foreign key(status_id) references STATUS_TYPE (status_id)
);

create table PLAN_TERM_COURSE_LNK(
ptc_lnk_id int AUTO_INCREMENT,
plan_id int,
term_id int,
course_id int,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint plan_id_fk3
foreign key (plan_id) references ACADEMIC_PLAN_TBL (plan_id),
constraint term_id_fk2
foreign key (term_id) references TERM_TBL (term_id),
constraint course_id_fk2 
foreign key (course_id) references COURSE_TBL(course_id),
primary key(ptc_lnk_id)
);

-- create table PTC_COMMENT_TBL(
-- ptc_comment_id int AUTO_INCREMENT,
-- ptc_lnk_id int,
-- comment_text text,
-- constraint ptc_lnk_id_fk
-- foreign key (ptc_lnk_id) references PLAN_TERM_COURSE_LNK(ptc_lnk_id),
-- primary key (ptc_comment_id)
-- );


create table USER_PROGRAM_LNK(
user_id int,
program_id int,
role_id int,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint user_id_fk5
foreign key (user_id) references USER_TBL (user_id),
constraint program_id_fk4
foreign key (program_id) references PROGRAM_TBL (program_id),
constraint role_id_fk
foreign key (role_id) references ROLE_TBL(role_id),
primary key (user_id, program_id)
);

create table TRACK_TBL(
track_id int AUTO_INCREMENT,
track_name varchar(50),
track_desc text,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key (track_id)
);

create table COURSE_TRACK_PROGRAM_LNK(
course_track_program_id int AUTO_INCREMENT,
course_id int,
track_id int,
program_id int,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint course_id_fk5
foreign key (course_id) references COURSE_TBL (course_id),
constraint track_id_fk
foreign key (track_id) references TRACK_TBL (track_id),
constraint program_id_fk5
foreign key (program_id) references PROGRAM_TBL (program_id),
primary key (course_track_program_id)
);

create table INSTRUCTOR_LNK(
faculty_id int,
course_id int,
is_primary boolean,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint faculty_id_fk
foreign key (faculty_id) references USER_TBL (user_id),
constraint course_id_fk6
foreign key (course_id) references COURSE_TBL (course_id),
primary key (faculty_id, course_id)
);

create table JOBSHEET_TBL(
jobsheet_id int AUTO_INCREMENT,
jobsheet_name varchar(50),
jobsheet_desc text,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key (jobsheet_id)
);

create table COURSE_JOBSHEET_LNK(
course_id int,
jobsheet_id int,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint course_id_fk7
foreign key (course_id) references COURSE_TBL (course_id),
constraint jobsheet_id_fk
foreign key (jobsheet_id) references JOBSHEET_TBL (jobsheet_id),
primary key (course_id, jobsheet_id)
);

create table SPEC_TBL(
spec_id int AUTO_INCREMENT,
spec_name varchar(50),
spec_desc text,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key (spec_id)
);

create table COMPANY_ORG_TBL(
org_id int AUTO_INCREMENT,
org_name varchar(50),
org_desc varchar(200),
phone varchar(10),
email varchar(50),
address varchar(50),
contacts text,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key (org_id)
);

create table COMPANY_JOBSHEET_LNK(
org_id int,
jobsheet_id int,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint org_id_fk
foreign key (org_id) references COMPANY_ORG_TBL (org_id),
constraint jobsheet_id_fk2
foreign key (jobsheet_id) references JOBSHEET_TBL (jobsheet_id),
primary key (org_id, jobsheet_id)
);

create table JOBSHEET_SPEC_LNK(
spec_id int,
jobsheet_id int,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint jobsheet_id_fk3
foreign key (jobsheet_id) references JOBSHEET_TBL (jobsheet_id),
constraint spec_id_fk
foreign key (spec_id) references SPEC_TBL (spec_id),
primary key(spec_id, jobsheet_id)
);

create table COMPETENCY_TBL(
competency_id int AUTO_INCREMENT,
competency_parent_id int,
competency_type varchar(50), -- I think this should be an enum, or a link to another table?
competency_name varchar(50),
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint competency_parent_id_fk
foreign key (competency_parent_id) references COMPETENCY_TBL(competency_id),
primary key (competency_id)
);

create table COURSE_COMPETENCY_LNK(
course_id int,
competency_id int,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint course_id_fk_7
foreign key (course_id) references COURSE_TBL (course_id),
constraint competency_id_fk
foreign key (competency_id) references COMPETENCY_TBL (competency_id),
primary key (course_id, competency_id)
);

create table LAB_PROJECT_TBL(
lab_project_id int AUTO_INCREMENT,
project_parent_id int,
lab_project_name varchar(50),
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint project_parent_id_fk
foreign key (project_parent_id)
references LAB_PROJECT_TBL (lab_project_id),
primary key (lab_project_id)
);

create table LAB_COMPONENT_TBL(
lab_component_id int AUTO_INCREMENT,
lab_component_name varchar(50),
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
primary key (lab_component_id)
);

create table PROJECT_PORTFOLIO_LNK(
course_id int,
lab_project_id int,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint course_id_fk_8
foreign key (course_id) references COURSE_TBL (course_id),
constraint lab_project_id_fk
foreign key (lab_project_id) references LAB_PROJECT_TBL (lab_project_id),
primary key(course_id, lab_project_id)
);

create table LAB_USE_CASE_LNK(
lab_use_case_id int AUTO_INCREMENT,
lab_component_id int,
course_id int,
lab_project_id int,
comment_set_id int,
foreign key (comment_set_id) references COMMENT_SET(comment_set_id),
constraint lab_component_id_fk
foreign key (lab_component_id) references LAB_COMPONENT_TBL(lab_component_id),
constraint course_id_fk_9
foreign key (course_id) references COURSE_TBL (course_id),
constraint lab_project_id_fk2
foreign key (lab_project_id) references LAB_PROJECT_TBL (lab_project_id),
primary key (lab_use_case_id)
);

/* create table MASTER_COMMENT_TBL(
comment_id int AUTO_INCREMENT,
comment_text text,
record_id int,  -- this is a foreign key, but to basically any other table
person_id int,
date datetime,
user_id int,
constraint person_id_fk
foreign key (person_id) references USER_TBL(user_id),
primary key (comment_id)
); */


/*
model Account {
  id                 String  @id @default(cuid())
  userId             String
  type               String
  provider           String
  providerAccountId  String
  refresh_token      String?
  access_token       String?
  expires_at         Int?
  ext_expires_in     Int?
  token_type         String?
  scope              String?
  id_token           String?
  session_state      String?
  oauth_token_secret String?
  oauth_token        String?

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@unique([provider, providerAccountId])
}
*/

/*
model User {
  id            String    @id @default(cuid())
  name          String?                         //used
  email         String?   @unique               //used
  emailVerified DateTime?
  image         String?
  accounts      Account[]
  sessions      Session[]
  role          Role      @default(student)     //used
  program       Program?  @relation(fields: [programId], references: [id])
  programId     String?
  plans         Plan[]
}
*/

/*
drop view if exists User;
CREATE VIEW User AS
SELECT user_tbl.user_id AS id, concat(user_tbl.first_name, ' ', user_tbl.last_name) AS name, user_tbl.email AS email, from dunwoody_advising_schema.USER_TBL as user_tbl;
*/

/*
model Course {
  id          String  @id @default(cuid())
  title       String
  code        String  @unique
  credits     Int
  //clockHours  Int
  //required    Boolean
  description String?
  //term        Term?   @relation(fields: [termId], references: [id])
  //termId      String?
}
*/
drop view if exists Course;
CREATE VIEW Course AS
SELECT COURSE_TBL.course_id, COURSE_TBL.program_id as course_program_id, PROGRAM_TBL.program_id, PROGRAM_TBL.program_name as title,
COURSE_TBL.course_code as code, PROGRAM_TBL.program_credits as credits,
COURSE_TBL.course_description as description
from COURSE_TBL JOIN PROGRAM_TBL ON COURSE_TBL.program_id = PROGRAM_TBL.program_id;

/*
CREATE VIEW Account
AS
SELECT
id, userId, type, provider,
providerAccountId, refresh_token, access_token, expires_at,
ext_expires_in, token_type, scope, id_token,
session_state, oauth_token_secret, oauth_token
FROM
*/