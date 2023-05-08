function Add-Project {
    # Prompts the user to enter a name for the microservice
    $microserviceName = Read-Host "Enter microservice $i name"
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
    dotnet add "$microservicePath/$microserviceName.Application/$microserviceName.Application.csproj" reference "$microservicePath/$microserviceName.Domain/$microserviceName.Domain.csproj"
    dotnet add "$microservicePath/$microserviceName.Infrastructure/$microserviceName.Infrastructure.csproj" reference "$microservicePath/$microserviceName.Application/$microserviceName.Application.csproj"
    dotnet add "$microservicePath/$microserviceName.Api/$microserviceName.Api.csproj" reference "$microservicePath/$microserviceName.Application/$microserviceName.Application.csproj"
    
    #Adding Project Reference to Test Project
    dotnet add "$solutionPath/tests/$microserviceName.Tests/$microserviceName.Tests.csproj" reference "$microservicePath/$microserviceName.Domain/$microserviceName.Domain.csproj"
    dotnet add "$solutionPath/tests/$microserviceName.Tests/$microserviceName.Tests.csproj" reference "$microservicePath/$microserviceName.Application/$microserviceName.Application.csproj"
    dotnet add "$solutionPath/tests/$microserviceName.Tests/$microserviceName.Tests.csproj" reference "$microservicePath/$microserviceName.Api/$microserviceName.Api.csproj"
    dotnet add "$solutionPath/tests/$microserviceName.Tests/$microserviceName.Tests.csproj" reference "$microservicePath/$microserviceName.Infrastructure/$microserviceName.Infrastructure.csproj"

    Write-Host "Microservice '$microserviceName' has been successfully created."
}

function New-Service {
    $addnewservice = Read-Host "Do you add new service to?(Y/N)"
    while ($addnewservice.ToUpper() -eq "Y") {
        Add-Project
        $addnewservice = Read-Host "Do you add another new service to?(Y/N)"
    } 
    
}


# Prompt user for solution name and create path
$solutionName = Read-Host "Enter solution name"
$appPath = Read-Host "Enter Application Path"

$solutionPath = Join-Path -Path $appPath -ChildPath $solutionName

# Check if solution already exists
if (Test-Path "$solutionPath/$solutionName.sln") {

    Write-Host "Solution Exists"
    New-Service
    break;
}

else {
    # Creates the solution directory
    New-Item -ItemType Directory -Force -Path $solutionPath
    # Creates the solution file using the .NET CLI
    dotnet new sln -n $solutionName -o $solutionPath
    # Prompts the user to enter the number of microservices to create
    New-Service
}



Write-Host "Complete"