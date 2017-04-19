
# get /r/subreddit/about
function Get-RedditSubAbout {
    <#
    .SYNOPSIS
        Function for getting about information from subreddit.
    .DESCRIPTION
        Function for getting about information from subreddit.
        Uses the /r/$Subreddit/about endpoint.
    .EXAMPLE
        Get-RedditSubAbout -Name "PowerShell"
        Gets the about information for the subreddit PowerShell.

    .EXAMPLE
        $res = Get-RedditSubAbout -Name "PowerShell" -Type moderators
        $res.data.children

    .NOTES
        Function added by Kreloc on 4/19/2017
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("r","Subreddit")]
        [string[]]
        $Name = 'all',
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("Link")]
        $accessToken = $Global:PSReddit_accessToken,
        # Parameter help description
        [Parameter(Position=2, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("banned","muted","wikibanned","contributors","wikicontributors","moderators","about")] 
        [String]
        $Type = "about"        
    )
    
    begin {
    }
    
    process {
        
        foreach ($sub in $Name) {
            If($Type -eq "about")
            {
                $uri = "https://oAuth.reddit.com/r/$sub/about"
            }
            else 
            {
                $uri = "https://oAuth.reddit.com/r/$sub/about/$Type"
            }
            Write-Verbose "Sending a uri of $($uri)"
            try {
                $response = (Invoke-RestMethod $uri -Headers @{"Authorization" = "bearer $accessToken"} -ErrorAction STOP)                
            }
            catch {
                # Expand this catch for the different errors returned
                Write-Error $_
                If($_.Exception -match 403)
                {
                    Write-Warning "This portion of the API is forbidden using the current authorized user"
                }
                Write-Warning "The last attempt against the Reddit API failed. May need to regenerate API token"
            }

            # TODO: Add formatting instead of piping to Select Object
            # $response
            # simple change to allow results from other points after /about
            If($type -eq "about")
            {
                $response | ForEach-Object {
                    $_.data | Select title, public_description, id, accounts_active, subscribers
                }
            }
            else 
            {
                $response    
            }
        }
    }
    
    end {
    }
}



# get /r/subreddit/<new,hot,etc>
function Get-RedditSubListing {
    <#
    .SYNOPSIS
        Function for getting listing of subreddit threads.
    .DESCRIPTION
        Function for getting listing of subreddit threads.
        Uses the /r/$Subreddit/ endpoint.
    .EXAMPLE
        Get-RedditSubListing -Name "PowerShell"
        Gets the hot listing result for the subreddit PowerShell.
    .EXAMPLE
        Get-RedditSubListing -Name "PowerShell" -Type controversial
        Gets the controversial listing result for the subreddit PowerShell.

    .NOTES
        Function added by Kreloc on 4/18/2017
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("r","Subreddit")]
        [string[]]
        $Name = 'all',
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true
            )]
        [Alias("Link")]
        $accessToken=$Global:PSReddit_accessToken,
        # Parameter help description
        [Parameter(Position=2, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("hot","new","random","rising","top","controversial")] 
        [String]
        $Type = "hot"
    )
    
    begin {
    }
    
    process {
        
        foreach ($sub in $Name) {
            $uri = "https://oAuth.reddit.com/r/$sub/$Type"
            Write-Verbose "Sending a uri of $($uri)"
            $response = (Invoke-RestMethod $uri -Headers @{"Authorization" = "bearer $accessToken"} -ErrorAction STOP)
            # TODO: Add formatting instead of piping to Select Object
            $response.data.children | ForEach-Object {
                $_.data | Select title, selfText, id, score, author, permalink, url, created_utc, num_comments, ups, downs
            }
            # Notes about data returned in above result
            # $test.data.children[0].data
            # selfText, id, score, author, permalink, url, created_utc, num_comments, ups, downs
        }
    }
    
    end {
    }
}