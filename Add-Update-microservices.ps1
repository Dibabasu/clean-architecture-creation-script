function Test-Input {
    param (
        [Parameter(Mandatory=$true)]
        [string]$input
    )
    if ($input -match "^[^a-zA-Z]|[^a-zA-Z0-9._-]") {
        Write-Host "Invalid input. Please start with a letter and use only alphanumeric characters, dots, dashes, or underscores."
        return $false
    }
    return $true
}

function Add-ProjectReference {
    param (
        [Parameter(Mandatory=$true)]
        [string]$project,
        [Parameter(Mandatory=$true)]
        [string[]]$references
    )
    foreach ($reference in $references) {
        try {
            dotnet add $project reference $reference
        } catch {
            Write-Host "Failed to add reference to $project. Error: $_"
        }
    }
}
function Add-Project {
    $i =[string]::Empty
    # Prompts the user to enter a name for the microservice
    do {
        $microserviceName = Read-Host "Enter microservice $i name"
    } until (Test-Input $microserviceName)
    # Constructs the path to the microservice directory
    $microservicePath = Join-Path -Path $solutionPath -ChildPath "src\$microserviceName"
     
    # Check if the microservice directory already exists
    if (Test-Path $microservicePath) {
        Write-Warning "A directory for microservice '$microserviceName' already exists."
        return
    }
	
    # Define an array of directories to create
    $dirs = @(
        "$microservicePath\$microserviceName.Domain",
        "$microservicePath\$microserviceName.Application",
        "$microservicePath\$microserviceName.Infrastructure",
        "$microservicePath\$microserviceName.Api",
        "$solutionPath\tests\$microserviceName.Tests"
    )
    $dirs | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ }


    # Creating Projects
    dotnet new classlib -n "$microserviceName.Domain" -o "$microservicePath/$microserviceName.Domain"
    dotnet new classlib -n "$microserviceName.Application" -o "$microservicePath/$microserviceName.Application"
    dotnet new classlib -n "$microserviceName.Infrastructure" -o "$microservicePath/$microserviceName.Infrastructure"
    dotnet new webapi -n "$microserviceName.Api" -o "$microservicePath/$microserviceName.Api"
    dotnet new xunit -n "$microserviceName.Tests" -o "$solutionPath/tests/$microserviceName.Tests"
	
    #Adding Projects to Solution
    dotnet sln $solutionPath add "$microservicePath/$microserviceName.Domain/$microserviceName.Domain.csproj"
    dotnet sln $solutionPath add "$microservicePath/$microserviceName.Application/$microserviceName.Application.csproj"
    dotnet sln $solutionPath add "$microservicePath/$microserviceName.Infrastructure/$microserviceName.Infrastructure.csproj"
    dotnet sln $solutionPath add "$microservicePath/$microserviceName.Api/$microserviceName.Api.csproj"
    dotnet sln $solutionPath add "$solutionPath/tests/$microserviceName.Tests/$microserviceName.Tests.csproj"
	
	
    #Adding Project Reference to Projects
    Add-ProjectReference "$microservicePath/$microserviceName.Application/$microserviceName.Application.csproj" @("$microservicePath/$microserviceName.Domain/$microserviceName.Domain.csproj")
    Add-ProjectReference "$microservicePath/$microserviceName.Infrastructure/$microserviceName.Infrastructure.csproj" @("$microservicePath/$microserviceName.Application/$microserviceName.Application.csproj")
    Add-ProjectReference "$microservicePath/$microserviceName.Api/$microserviceName.Api.csproj" @("$microservicePath/$microserviceName.Application/$microserviceName.Application.csproj")

    #Adding Project Reference to Test Project
    Add-ProjectReference "$solutionPath/tests/$microserviceName.Tests/$microserviceName.Tests.csproj" @("$microservicePath/$microserviceName.Domain/$microserviceName.Domain.csproj", "$microservicePath/$microserviceName.Application/$microserviceName.Application.csproj", "$microservicePath/$microserviceName.Api/$microserviceName.Api.csproj", "$microservicePath/$microserviceName.Infrastructure/$microserviceName.Infrastructure.csproj")

    Write-Host "Microservice '$microserviceName' has been successfully created."
}

function New-Service {
    $addnewservice = Read-Host "Do you add new service to?(Y/N)"
    while ($addnewservice.ToUpper() -eq "Y") {
        Add-Project
        $addnewservice = Read-Host "Do you add another new service to?(Y/N)"
    } 
    
}


do {
    $solutionName = Read-Host "Enter solution name"
} until (Test-Input $solutionName)

$appPath = Read-Host "Enter Application Path"

$solutionPath = Join-Path -Path $appPath -ChildPath $solutionName

# Check if solution already exists
if (Test-Path "$solutionPath/$solutionName.sln") {

    Write-Host "Solution Exists"
    New-Service
    break;
}

else {
    try {
        # Creates the solution directory
        New-Item -ItemType Directory -Force -Path $solutionPath
        # Creates the solution file using the .NET CLI
        dotnet new sln -n $solutionName -o $solutionPath
        # Prompts the user to enter the number of microservices to create
        New-Service
    } catch {
        Write-Host "An error occurred: $_"
    }
}



Write-Host "Complete"