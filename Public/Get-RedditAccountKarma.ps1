function Get-RedditAccountKarma {
    <#
    .SYNOPSIS
        Gets a breakdown of karma for reddit account module is authorized with.
    .DESCRIPTION
        Gets a breakdown of karma for reddit account module is authorized with.
        Uses the me/karma endpoint of Reddit API.
    .EXAMPLE
        Get-RedditAccountKarma
        Gets a breakdown of account Karma, using sr(subreddit), comment_karma, and link_karma as returned properties.

    .NOTES
        Added by Kreloc on 4/18/2017
    #>
    [CmdletBinding()]
        param ()
    
    begin {
    }
    
    process {
        # TODO - Use a $BaseURI script variable of https://oAuth.reddit.com/api/v1
        $uri = 'https://oAuth.reddit.com/api/v1/me/karma'
        $response = Invoke-RedditApi -uri $uri
        # No formatting, not sure its necessary for this
        $response.data
    }
    
    end {
    }
}