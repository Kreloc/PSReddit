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