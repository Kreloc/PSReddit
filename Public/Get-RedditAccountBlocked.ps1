function Get-RedditAccountBlocked {
    <#
    .SYNOPSIS
        Gets the blocked listing for account module is authorized with.
    .DESCRIPTION
         Gets the blocked listing for reddit account module is authorized with.
        Uses the me/blocked endpoint of Reddit API.
    .EXAMPLE
        Get-RedditAccountBlocked
         Gets the blocked listing for account module is authorized with.

    .NOTES
        Added by Kreloc on 4/18/2017
    #>
    [CmdletBinding()]
        param ()
    
    begin {
    }
    
    process {
        # TODO - Use a $BaseURI script variable of https://oAuth.reddit.com/api/v1
        $uri = 'https://oAuth.reddit.com/api/v1/me/blocked'
        $response = Invoke-RedditApi -uri $uri
        # No formatting, not sure its necessary for this
        $response.data
    }
    
    end {
    }
}