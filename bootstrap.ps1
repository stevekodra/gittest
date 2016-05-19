

          
          "$source = \"https://raw.githubusercontent.com/stevekodra/gittest/testinggit/DeployAD.ps1\"\n",
          "$destination = \"C:\\Scripts\\DeployAD.ps1\"\n",
          "Invoke-WebRequest $source -OutFile $destination \n",
          
          "$source1 = \"https://raw.githubusercontent.com/stevekodra/gittest/testinggit/DeployAD.ps1\"\n",
          "$destination1 = \"C:\\Scripts\\DeployAD.ps1\"\n",
          "Invoke-WebRequest $source -OutFile $destination1 \n",
          "$location = & 'C:\\Program Files\\Amazon\\Ec2ConfigService\\Scripts\\DeployAD.ps1' \n",
          "Invoke-Expression $location\n",