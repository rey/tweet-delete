#!/bin/bash

# tweet-delete.sh
#
# About
# Use this script to delete your tweets on a scheduled basis.
#
# Caveat
# The Twitter API only lets you get a maximum of 200 tweets per request (https://developer.twitter.com/en/docs/tweets/timelines/api-reference/get-statuses-user_timeline) and I haven't implemented support for cursoring because many moons ago I deleted all my tweets and it's unlikely I'll post > 200 tweets in a week.
#
# Set the twitter_user variable to your Twitter username (e.g. "reyhan")
twitter_user=reyhan

twurl \
    --consumer-key ${twitter_consumer_api_key} \
    --consumer-secret ${twitter_consumer_api_secret_key} \
    --access-token ${twitter_access_token} \
    --token-secret ${twitter_access_token_secret} \
    --request-method GET \
        "/1.1/statuses/user_timeline.json?screen_name=${twitter_user}&count=200&include_rts=true&trim_user=1" \
            | jq --raw-output ".[] | .id_str" > tweets_to_delete
    

if [[ -s tweets_to_delete ]]; then
    echo "There are tweets to delete!"
    while read tweet_id; do
        twurl \
            --consumer-key ${twitter_consumer_api_key} \
            --consumer-secret ${twitter_consumer_api_secret_key} \
            --access-token ${twitter_access_token} \
            --token-secret ${twitter_access_token_secret} \
            --request-method POST \
                "/1.1/statuses/destroy/${tweet_id}.json?trim_user=1"
    done < tweets_to_delete
else
    echo "There are no tweets to delete."
fi

rm tweets_to_delete