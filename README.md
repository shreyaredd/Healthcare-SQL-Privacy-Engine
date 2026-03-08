# Patient Privacy SQL Engine (HIPAA Masking)

## What is this?
I built this project to demonstrate how to handle sensitive healthcare data (PHI) in a database. The goal was to create a "safe" version of a patient table that researchers can use without seeing private details like full names or Social Security Numbers.

## How it works
I used **MySQL Views** to build a transformation layer. When you query the "Safe" view, the engine automatically:
* **Masks Names:** Swaps full names for initials (e.g., "John Smith" -> "J. S.").
* **Protects SSNs:** Hides everything except the last 4 digits.
* **Generalizes Birthdays:** Changes specific dates to just the **Birth Year** (following HIPAA Safe Harbor rules).
* **Truncates ZIP Codes:** Shows only the first 3 digits to hide specific locations.

## The Result
Instead of seeing sensitive data, the output looks like this:
(Result.png)

## Tools used
* **SQL (MySQL 8.0)**
* **DB Fiddle** (for testing and verification)
