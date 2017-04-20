function Remove-RedditPost {
    <#
    .SYNOPSIS
        A function for deleting a reddit post you made.
    .DESCRIPTION
        A function for deleting a reddit post you made.
        Uses the /api/del endpoint.
    .EXAMPLE
        Remove-RedditPost -id 66g5ot -Verbose
        Removes a redditpost by id specified.
    .EXAMPLE
        $new = New-RedditPost -Title "PSReddit Module Fork" -Url "https://github.com/Kreloc/PSReddit" -Subreddit PSRedditFork
        Remove-RedditPost -id $new.id
        Removes the reddit post created using New-RedditPost
    .EXAMPLE
        "https://www.reddit.com/r/redditdev/comments/3i9psm/how_can_i_find_the_id_of_the_original_post_in_a/" | Remove-RedditPost

        Would remove the post from the url piped to Remove-RedditPost if that post was created by
        the same user account as authorized for this module.

    .NOTES
        Will remove a post. Does not produce any output. Even the reddit api does not produce output during
        my testing of this function.
    #>
    [CmdletBinding()]
    param (
        # The id of the post to be removed
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $id
    )
    
    begin {
    }
    
    process {

        ## Depending on how we passed the id to the function, we need to
        ## strip some characters.
        switch ($id)
        {
            {($id -like "t3_*")}
            {
                $id = $id -replace "t3_", ""
                break
            }  
            {($id -like "http*")}
            {
                $id = $id.Split("/")[6]
                break
            }
        }

        $uri = "https://oAuth.reddit.com/api/del?id=t3_$id"
        Invoke-RedditApi -uri $uri -Method Post
    }
    
    end {
    }
}