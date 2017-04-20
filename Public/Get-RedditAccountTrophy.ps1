function Get-RedditAccountTrophy {
    <#
    .SYNOPSIS
        Gets the trophy list result for account module is authorized with.
    .DESCRIPTION
        Gets the trophy list result for reddit account module is authorized with.
        Uses the me/trophies endpoint of Reddit API.
    .EXAMPLE
        Get-RedditAccountTrophy
        Gets the trophy list result for account module is authorized with.

    .NOTES
        Added by Kreloc on 4/18/2017
    #>
    [CmdletBinding()]
        param ()
    
    begin {
    }
    
    process {
        # TODO - Use a $BaseURI script variable of https://oAuth.reddit.com/api/v1
        $uri = 'https://oAuth.reddit.com/api/v1/me/trophies'
        $response = Invoke-RedditApi -uri $uri
        # No formatting, not sure its necessary for this
        $response.data.trophies | ForEach-Object {
            $_.data
        }
    }
    
    end {
    }
}