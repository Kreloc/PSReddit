# internal invoke function
function Invoke-RedditApi {
    [CmdletBinding()]
    param (
        $uri,
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("Link")]
        $accessToken=$Global:PSReddit_accessToken
    )
    
    begin {
    }
    
    process {
        Write-Verbose "Sending a uri of $($uri)"
        try {
            $response = (Invoke-RestMethod $uri -Headers @{"Authorization" = "bearer $accessToken"} -ErrorAction STOP)                
        }
        catch {
            # Expand this catch for the different errors returned
            Write-Error $_
            If($_.Exception -match 400)
            {
                Write-Warning "The uri sent was seen as malformed, check the content of $($uri)"
            }
            If($_.Exception -match 403)
            {
                Write-Warning "This portion of the API is forbidden using the current authorized user"
            }
            If($_.Exception -match 404)
            {
                Write-Warning "No results were found using the uri: $($uri)"
            }
            If($_.Exception -match 401)
            {
                Write-Warning "The last attempt against the Reddit API failed. May need to regenerate API token"
            }
            If($_.Exception -match 500)
            {
                Write-Warning "There was an error at the other end. Try again later"
            }           
        }
        $response        
    }
    
    end {
    }
}
# end internal invoke function

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
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("r","Subreddit")]
        [string[]]
        $Name = 'all',
        # Parameter help description
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("banned","muted","wikibanned","contributors","wikicontributors","moderators","rules","about")] 
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
            $response = Invoke-RedditApi -uri $uri
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

# get /api/recommend/sr/$srnames
function Get-RedditSubRecommendation {
    [CmdletBinding()]
    param (
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("r","Subreddit")]
        [string[]]
        $Name = 'all',
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("Link")]
        $accessToken = $Global:PSReddit_accessToken        
    )
    
    begin {

    }
    
    process {
        $Names = $Name -join ','
        $uri = "https://oAuth.reddit.com/api/recommend/sr/$Names"
        $response = Invoke-RedditApi -uri $uri
        $response
    }
    
    end {
    }
}

# get /r/subreddit/api/submit_text

# get /api/subreddits_by_topic
function Search-SubredditByTopic
{
    <#
    .SYNOPSIS
        A function for finding subreddits by a topic query.
    .DESCRIPTION
        A function for finding subreddits by a topic query.
        Uses the /api/subreddits_by_topic endpoint
    .EXAMPLE
        Search-SubredditByTopic -Filter "helpdesk"
        Returns subreddits found with a topic relating to helpdesk.
    #>  
    [CmdletBinding()]
    param (
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("query")]
        [string]
        $Filter = 'all'  
    )
    begin {}
    process {
        $uri = "https://oAuth.reddit.com/api/subreddits_by_topic?query=$Filter"
        $response = Invoke-RedditApi -uri $uri           
        $response
    }
    end {}
}

# get /r/subreddit/sidebar
function Get-RedditSubSideBar {
    <#
    .SYNOPSIS
        Function for getting sidebar content of subreddit(s).
    .DESCRIPTION
        Function for getting sidebar content of subreddit(s)
        Uses the /r/$Subreddit/sidebar endpoint.
    .EXAMPLE
        Get-RedditSubSideBar -Name "PowerShell"
        Gets the sidebar content for the subreddit PowerShell.

    .NOTES
        Function added by Kreloc on 4/18/2017

        Does not work, comes back as 400 Bad Request, not sure why
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
        $accessToken=$Global:PSReddit_accessToken
    )
    
    begin {
    }
    
    process {
        
        foreach ($sub in $Name) {
            $uri = "https://oAuth.reddit.com/r/$sub/sidebar"
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

# get /subreddits/mine/where
function Get-RedditSubsUser {
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
        [ValidateSet("subscriber","contributor","moderator")] 
        [String]
        $Type = "subscriber"                
    )
    
    begin {
    }
    
    process {
        $uri = "https://oAuth.reddit.com/subreddits/mine/$Type"
        Write-Verbose "Sending a uri of $($uri)"
        $response = (Invoke-RestMethod $uri -Headers @{"Authorization" = "bearer $accessToken"} -ErrorAction STOP)        
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