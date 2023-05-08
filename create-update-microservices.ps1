function Create-Project {
    # Prompts the user to enter a name for the microservice
    $microserviceName = Read-Host "Enter microservice $i name"
    # Constructs the path to the microservice directory
	$microservicePath = Join-Path -Path $solutionPath -ChildPath "src\$microserviceName"
	
	# Creating Directories
    New-Item -ItemType Directory -Force -Path $microservicePath
    New-Item -ItemType Directory -Force -Path "$microservicePath\$microserviceName.Domain"
    New-Item -ItemType Directory -Force -Path "$microservicePath\$microserviceName.Application"
    New-Item -ItemType Directory -Force -Path "$microservicePath\$microserviceName.Infrastructure"
    New-Item -ItemType Directory -Force -Path "$microservicePath\$microserviceName.Api"
    New-Item -ItemType Directory -Force -Path "$solutionPath\tests\$microserviceName.Tests"

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
    dotnet add "$microservicePath/$microserviceName.Infrastructure/$microserviceName.Infrastructure.csproj" reference "$microservicePath/$microserviceName.Domain/$microserviceName.Domain.csproj"
    dotnet add "$microservicePath/$microserviceName.Api/$microserviceName.Api.csproj" reference "$microservicePath/$microserviceName.Application/$microserviceName.Application.csproj"
    dotnet add "$microservicePath/$microserviceName.Api/$microserviceName.Api.csproj" reference "$microservicePath/$microserviceName.Infrastructure/$microserviceName.Infrastructure.csproj"
    
	dotnet add "$solutionPath/tests/$microserviceName.Tests/$microserviceName.Tests.csproj" reference "$microservicePath/$microserviceName.Domain/$microserviceName.Domain.csproj"
    dotnet add "$solutionPath/tests/$microserviceName.Tests/$microserviceName.Tests.csproj" reference "$microservicePath/$microserviceName.Application/$microserviceName.Application.csproj"
	dotnet add "$solutionPath/tests/$microserviceName.Tests/$microserviceName.Tests.csproj" reference "$microservicePath/$microserviceName.Api/$microserviceName.Api.csproj"
    dotnet add "$solutionPath/tests/$microserviceName.Tests/$microserviceName.Tests.csproj" reference "$microservicePath/$microserviceName.Infrastructure/$microserviceName.Infrastructure.csproj"
}


# Prompt user for solution name and create path
$solutionName = Read-Host "Enter solution name"
$solutionPath = Join-Path -Path $PWD -ChildPath $solutionName

# Check if solution already exists
if (Test-Path "$solutionPath/$solutionName.sln") {

    Write-Host "Solution Exists"
    $numberOfMicroservices = Read-Host "Do you add a Service?(Y/N)"
    if ($numberOfMicroservices.ToUpper() -eq "Y")
    {
        Create-Project 
    }
    
    break;
    
}

else {
    # Creates the solution directory
    New-Item -ItemType Directory -Force -Path $solutionPath
    # Creates the solution file using the .NET CLI
    dotnet new sln -n $solutionName -o $solutionPath
    # Prompts the user to enter the number of microservices to create
    $numberOfMicroservices = Read-Host "Enter number of microservices"
    # Loops through the number of microservices and creates the necessary projects
    for ($i=1; $i -le $numberOfMicroservices; $i++) { 
	
        Create-Project 
    }
}



Write-Host "Complete"