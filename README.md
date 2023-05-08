Microservice Solution Creator
This script is designed to create a new .NET solution with multiple microservices. It prompts the user to enter a solution name and application path, and then creates the solution directory and file using the .NET CLI. The user is then prompted to enter the number of microservices to create, and for each microservice, the script creates a directory structure and adds projects to the solution.

Usage
Open PowerShell
Navigate to the directory where the script is saved
Run the script using the command .\Add-Update-microservices.ps1
Follow the prompts to enter the solution name and application path
Enter the number of microservices to create
Follow the prompts to enter the name of each microservice
Script Details
Add-Project Function
This function is called for each microservice and performs the following tasks:

Prompts the user to enter a name for the microservice
  Constructs the path to the microservice directory
  Checks if the microservice directory already exists
  Defines an array of directories to create
  Creates the directories using the New-Item cmdlet
  Creates the microservice projects using the .NET CLI
  Adds the microservice projects to the solution using the .NET CLI
  Adds project references to the microservice projects using the .NET CLI
  Adds project references to the test project using the .NET CLI
  Writes a success message to the console
  New-Service Function
  This function is called to prompt the user to enter the number of microservices to create, and then calls the Add-Project function for each microservice.

Solution Creation
The script prompts the user to enter a solution name and application path, and then checks if the solution already exists. If the solution exists, the user is prompted to enter the number of microservices

Requirements
PowerShell version 5.1 or later
.NET Core SDK version 3.1 or later
