-- Everest School Management System Database Schema & Initial Data
CREATE DATABASE IF NOT EXISTS `school_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `school_db`;

-- Drop existing tables if present in correct dependency order
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `inquiries`;
DROP TABLE IF EXISTS `settings`;
DROP TABLE IF EXISTS `assignments`;
DROP TABLE IF EXISTS `gallery`;
DROP TABLE IF EXISTS `events`;
DROP TABLE IF EXISTS `notices`;
DROP TABLE IF EXISTS `attendance`;
DROP TABLE IF EXISTS `results`;
DROP TABLE IF EXISTS `subjects`;
DROP TABLE IF EXISTS `students`;
DROP TABLE IF EXISTS `classes`;
DROP TABLE IF EXISTS `teachers`;
DROP TABLE IF EXISTS `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- Users Table
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','teacher','student') NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Teachers Table
CREATE TABLE `teachers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `department` varchar(50) DEFAULT NULL,
  `designation` varchar(50) DEFAULT NULL,
  `photo_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `teachers_user_id_idx` (`user_id`),
  CONSTRAINT `fk_teachers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Classes Table
CREATE TABLE `classes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(50) NOT NULL,
  `stream` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Students Table
CREATE TABLE `students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `roll_no` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `class_id` int(11) NOT NULL,
  `dob` date DEFAULT NULL,
  `parent_name` varchar(100) DEFAULT NULL,
  `parent_phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roll_no` (`roll_no`),
  KEY `students_user_id_idx` (`user_id`),
  KEY `students_class_id_idx` (`class_id`),
  CONSTRAINT `fk_students_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_students_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Subjects Table
CREATE TABLE `subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) NOT NULL,
  `subject_name` varchar(100) NOT NULL,
  `teacher_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subjects_class_id_idx` (`class_id`),
  KEY `subjects_teacher_id_idx` (`teacher_id`),
  CONSTRAINT `fk_subjects_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_subjects_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Assignments Table
CREATE TABLE `assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `due_date` date NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `assignments_class_id_idx` (`class_id`),
  KEY `assignments_subject_id_idx` (`subject_id`),
  CONSTRAINT `fk_assignments_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_assignments_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Results Table
CREATE TABLE `results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `exam_term` varchar(50) NOT NULL,
  `marks_obtained` decimal(5,2) NOT NULL,
  `total_marks` decimal(5,2) NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_subject_term` (`student_id`, `subject_id`, `exam_term`),
  KEY `results_student_id_idx` (`student_id`),
  KEY `results_subject_id_idx` (`subject_id`),
  CONSTRAINT `fk_results_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_results_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Attendance Table
CREATE TABLE `attendance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `status` enum('present','absent','late') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_date` (`student_id`, `date`),
  KEY `attendance_student_id_idx` (`student_id`),
  CONSTRAINT `fk_attendance_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Notices Table
CREATE TABLE `notices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `notices_created_by_idx` (`created_by`),
  CONSTRAINT `fk_notices_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Events Table
CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `event_date` date NOT NULL,
  `event_time` time DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Gallery Table
CREATE TABLE `gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `category` enum('school_activities','sports','events','labs','other') NOT NULL,
  `type` enum('image','video') NOT NULL,
  `media_url` varchar(255) NOT NULL,
  `uploaded_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Settings Table
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inquiries Table
CREATE TABLE `inquiries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_name` varchar(100) NOT NULL,
  `parent_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `class_applied` varchar(50) DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed Data

-- 1. Users (Password is 'admin123' for all seeded accounts)
INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
(1, 'admin', '$2y$10$K1lWxEpf5nKyxld2oiUcUO4upNtLdaoMQRzyEYZJjaARIEuGx/MEG', 'admin'),
(2, 'teacher1', '$2y$10$K1lWxEpf5nKyxld2oiUcUO4upNtLdaoMQRzyEYZJjaARIEuGx/MEG', 'teacher'),
(3, 'student1', '$2y$10$K1lWxEpf5nKyxld2oiUcUO4upNtLdaoMQRzyEYZJjaARIEuGx/MEG', 'student');

-- 2. Classes
INSERT INTO `classes` (`id`, `class_name`, `stream`) VALUES
(1, 'Class 9', 'General'),
(2, 'Class 10', 'General'),
(3, 'Class 11', 'Science & Computer'),
(4, 'Class 12', 'Science & Computer');

-- 3. Teachers
INSERT INTO `teachers` (`id`, `user_id`, `name`, `email`, `phone`, `department`, `designation`, `photo_url`) VALUES
(1, 2, 'Er. Rajesh Koirala', 'rajesh.koirala@everest.edu.np', '+977-9841234567', 'Science & Technology', 'Senior Lecturer', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80'),
(2, NULL, 'Sunita Sharma', 'sunita.sharma@everest.edu.np', '+977-9851234568', 'Mathematics', 'Head of Department', 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80');

-- 4. Students
INSERT INTO `students` (`id`, `user_id`, `roll_no`, `name`, `class_id`, `dob`, `parent_name`, `parent_phone`, `address`) VALUES
(1, 3, 'STD-1001', 'Aarav Shrestha', 2, '2010-05-15', 'Bikram Shrestha', '+977-9812345678', 'Kathmandu, Bagmati');

-- 5. Subjects
INSERT INTO `subjects` (`id`, `class_id`, `subject_name`, `teacher_id`) VALUES
(1, 2, 'Mathematics', 2),
(2, 2, 'Science', 1),
(3, 2, 'Computer Science', 1),
(4, 2, 'English', NULL);

-- 6. Assignments
INSERT INTO `assignments` (`id`, `class_id`, `subject_id`, `title`, `description`, `file_url`, `due_date`) VALUES
(1, 2, 2, 'Physics: Laws of Motion Numerical Problems', 'Complete exercises from Chapter 3 (Page 45-48). Show all calculations and diagrams neatly.', '', DATE_ADD(CURRENT_DATE, INTERVAL 5 DAY)),
(2, 2, 3, 'HTML & CSS Portfolio Project', 'Design a 3-page responsive personal portfolio using semantic HTML5 and CSS Flexbox/Grid.', '', DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY));

-- 7. Results
INSERT INTO `results` (`id`, `student_id`, `subject_id`, `exam_term`, `marks_obtained`, `total_marks`, `remarks`) VALUES
(1, 1, 1, 'First Term', 88.50, 100.00, 'Excellent performance'),
(2, 1, 2, 'First Term', 92.00, 100.00, 'Outstanding analytical ability'),
(3, 1, 3, 'First Term', 95.00, 100.00, 'Top of class in coding practicals');

-- 8. Attendance
INSERT INTO `attendance` (`id`, `student_id`, `date`, `status`) VALUES
(1, 1, CURRENT_DATE, 'present');

-- 9. Notices
INSERT INTO `notices` (`id`, `title`, `content`, `file_url`, `created_by`) VALUES
(1, 'Welcome to Academic Session 2026-2027', 'Everest School welcomes all new and returning students! Classes will commence from next Sunday with exciting digital curriculum upgrades and new campus amenities.', NULL, 1),
(2, 'Annual Inter-House Sports Gala 2026', 'Registrations are open for track & field, football, basketball, and chess tournaments. Contact your house captains by this Friday.', NULL, 1),
(3, 'Parent-Teacher Conference Schedule', 'The First Term academic review meeting with parents will be held on Saturday from 10:00 AM to 3:00 PM. All parents are kindly requested to participate.', NULL, 1);

-- 10. Events
INSERT INTO `events` (`id`, `title`, `description`, `event_date`, `event_time`, `location`, `image_url`) VALUES
(1, 'Science & Robotics Exhibition 2026', 'Students demonstrate autonomous robots, IoT smart city models, and AI assistants.', DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY), '10:00:00', 'Everest Auditorium', 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?auto=format&fit=crop&w=800&q=80');

-- 11. Gallery
INSERT INTO `gallery` (`id`, `title`, `category`, `type`, `media_url`) VALUES
(1, 'Modern Computing Lab Session', 'labs', 'image', 'https://images.unsplash.com/photo-1562774053-701939374585?auto=format&fit=crop&w=800&q=80'),
(2, 'Annual Football Championship', 'sports', 'image', 'https://images.unsplash.com/photo-1546410531-bb4caa6b424d?auto=format&fit=crop&w=800&q=80'),
(3, 'Graduation Ceremony & Awards', 'events', 'image', 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&w=800&q=80');

-- 12. Settings
INSERT INTO `settings` (`setting_key`, `setting_value`) VALUES
('school_name', 'Everest English High School'),
('school_email', 'info@everestschool.edu.np'),
('school_phone', '+977-01-445566'),
('school_address', 'Kathmandu, Nepal');
