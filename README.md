# Records SQL Queries

This repository contains SQL queries, Python scripts, and related utilities used to support Admissions and Records operations at Nashville State Community College.

## Repository Contents

The repository includes scripts supporting areas such as:

- Admissions
- Registration
- Graduation and commencement
- Student records
- Veterans Affairs reporting and processing
- Course scheduling and cleanup
- Degree Works and prerequisite processing
- Slate-related processes
- Banner reporting and data validation
- Institutional and ad hoc reporting

Many of the SQL scripts are designed for use with Ellucian Banner and Oracle SQL Developer. Python scripts are used for data processing, file generation, validation, and other administrative workflows.

## Data Privacy

This repository is intended for program code, SQL queries, documentation, and related development files only.

Student-level data and report output should not be stored in this repository.

The `.gitignore` file is configured to exclude common data output formats, including:

- Excel files (`.xlsx` and `.xls`)
- CSV files (`.csv`)
- Temporary Excel files

Before committing changes, always review the files being staged with:

    git status

Do not commit files containing personally identifiable information (PII), student education records, credentials, passwords, API keys, or other sensitive institutional information.

## Updating the Repository

To update the repository after making changes:

    git status
    git add .
    git commit -m "Description of changes"
    git push

The `git status` command should be reviewed before committing to ensure that only appropriate files are being added to the repository.

## Notes

Scripts in this repository may be specific to Nashville State Community College's Banner configuration, business processes, database objects, and local procedures.

Queries and programs should be reviewed and tested before being used in a production environment.

## Maintainer

Kevin Thomas  
Admissions and Records  
Nashville State Community College
