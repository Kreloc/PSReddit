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
            $response = Invoke-RedditApi -uri $uri
            # TODO: Add formatting instead of piping to Select Object
            $response
        }
    }
    
    end {
    }
}