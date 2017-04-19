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

    .NOTES
        Function added by Kreloc on 4/19/2017
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
            $uri = "https://oAuth.reddit.com/r/$sub/about"
            Write-Verbose "Sending a uri of $($uri)"
            try {
                $response = (Invoke-RestMethod $uri -Headers @{"Authorization" = "bearer $accessToken"} -ErrorAction STOP)                
            }
            catch {
                # Expand this catch for the different errors returned
                Write-Warning "The last attempt against the Reddit API failed. May need to regenerate API token"
            }

            # TODO: Add formatting instead of piping to Select Object
            # $response
            $response | ForEach-Object {
                $_.data | Select title, public_description, id, accounts_active, subscribers
            }
        }
    }
    
    end {
    }
}