;Z Custom Aliases

alias displayName {
  var %j = followUser_ $+ $ticks
  JSONOpen -ud %j https://api.twitch.tv/kraken/channels/ $+ $1 $+ ?= $+ $rand(1,1000000)
  var %displayName = $json(%j,display_name)
  return %displayName
}

alias followGame {
  var %j = followUser
  JSONOpen -ud %j https://api.twitch.tv/kraken/channels/ $+ $1 $+ ?= $+ $rand(1,1000000)
  var %followGame = $json(%j,game)
  return %followGame
}

alias followName {
  var %j = followUser_ $+ $ticks $+ $ctime
  JSONOpen -ud %j https://api.twitch.tv/kraken/channels/ $+ $1 $+ ?= $+ $ticks
  var %displayName = $json(%j,display_name)
  return %displayName
}

alias streamTitle {
  var %j = titleUser
  JSONOpen -ud %j https://api.twitch.tv/kraken/channels/ $+ $1 $+ ?= $+ $ticks
  var %titleUser = $json(%j,status)
  return %titleUser
}

alias streamGame {
  if (!$1) { return }
  if ($me !ison $1) { return }
  var %j = followUser
  JSONOpen -ud %j https://api.twitch.tv/kraken/channels/ $+ $1 $+ ?= $+ $ticks
  var %streamGame = $json(%j,game)
  return %streamGame
}

alias streamGameOnline {
  if (!$1) { return }
  if ($me !ison $1) { return }
  var %j = followUser
  JSONOpen -ud %j https://api.twitch.tv/kraken/channels/ $+ $mid($1,2) $+ ?= $+ $ticks
  var %streamGame = $json(%j,game)
  if (%streamGame != $streamGame($mid($1,2))) {
    set %streamGame_ [ $+ [ $mid($1,2) ] ] %streamGame
  }
  set %streamGame_ [ $+ [ $mid($1,2) ] ] %streamGame
}


alias startTime {
  var %j = streamUptime
  JSONOpen -ud %j https://api.twitch.tv/kraken/streams/ $+ $1 $+ ?= $+ $ticks
  var %uptime = $ctime($replace($json(%j,stream,created_at),T,$chr(32),Z,))
  return %uptime
}

alias targetStatus {
  if (!$1) { return }
  var %j = targetStatus
  JSONOpen -ud %j https://api.twitch.tv/kraken/streams/ $+ $1 $+ ?= $+ $ticks
  var %targetStatus = $json(%j,stream)
  return %targetStatus
}


alias streamStatus {
  if (!$1) { return }
  if ($me !ison $1) { return }
  var %j = stream_ $+ $ticks $+ $ctime
  JSONOpen -ud %j https://api.twitch.tv/kraken/streams/ $+ $mid($1,2) $+ ?= $+ $ticks
  var %status = $json(%j,stream)

  if (!%status && %check_ [ $+ [ $mid($1,2) ] ] == 0 ) {
    set %check_ $+ $mid($1,2) 1
  }

  if (!%status && (%check_ [ $+ [ $mid($1,2) ] ] == 1)) {  
    set %status_ [ $+ [ $mid($1,2) ] ] Offline 
    set %check_ $+ $mid($1,2) 0
    /timer[CTT_ [ $+ [ $1 ] ] $+ ] off
  }

  if (%status_ [ $+ [ $mid($1,2) ] ] == Online && (%check_ [ $+ [ $mid($1,2) ] ] == 1)) {
    set %check_ $+ $mid($1,2) 0
    autoTweet $1
  }

  if (%status_ [ $+ [ $mid($1,2) ] ] == Online) {
    set %check_ $+ $mid($1,2) 0
    autoTweet $1
    return
  }

  if (%status) {
    set %status_ [ $+ [ $mid($1,2) ] ] Online
    msg $1 /me - We're live with $followGame($mid($1,2)) $+ . Sit back and enjoy the show. 
    unset %greeting_ [ $+ [ $mid($1,2) ] [ $+ _* ] ]
    set %check_ $+ $mid($1,2) 0
    autoTweet $1
  }
}

alias urlencode { return $regsubex($1-,/([^a-z0-9])/ig,% $+ $base($asc(\t),10,16,2)) }

alias tinyurl {
  if (!$1) { return }
  if (http* !iswm $1) { var %one = http:// $+ $1 }
  elseif (http* iswm $1) { var %one = $1 }
  var %url = http://tinyurl.com/api-create.php?url= $+ %one
  var %com = tinyurl_ $+ $ticks
  .comopen %com MSXML2.SERVERXMLHTTP 
  noop $com(%com, Open,1, bstr,GET,bstr,%url,bool,false) $com(%com,Send,1) $com(%com,ResponseText,2)
  var %a $com(%com).result
  if ($com(%com)) { .comclose %com }
  return %a
}

alias autoTweet {
  var %file = data\Current_Game\gamelist.ini
  var %handle = $readini(%file,n,$1,twitter)
  if (!%handle) { halt }
  if ((%autotweet_ [ $+ [ $mid($1,2) ] ]) && (%streamGame_ [ $+ [ $mid($1,2) ] ] !isin %autotweet_ [ $+ [ $mid($1,2) ] ])) {
    var -g %autotweet_ [ $+ [ $mid($1,2) ] ] Come join %handle playing %streamGame_ [ $+ [ $mid($1,2) ] ] $+ . http://twitch.tv/ $+ $mid($1,2)
    var %encodedtweet = https://twitter.com/intent/tweet?text= $+ $urlencode(%autotweet_ [ $+ [ $mid($1,2) ] ])
    var -g %tweet_ [ $+ [ $mid($1,2) ] ] $tinyurl(%encodedtweet)
    msg $1 /me - Game Updated: %tweet_ [ $+ [ $mid($1,2) ] ]
    .timer[CTT_ [ $+ [ $1 ] ] $+ ] off
    .timer[CTT_ [ $+ [ $1 ] ] $+ ] 0 3600 msg $1 /me - Consider tweeting the stream to get more people in here to enjoy the show! %tweet_ [ $+ [ $mid($1,2) ] ]
  }

  if ($timer([CTT_ [ $+ [ $1 ] ] $+ ]).type == online) { return }
  if (!%tweet_ [ $+ [ $mid($1,2) ] ] && %handle) {
    var -g %autotweet_ [ $+ [ $mid($1,2) ] ] Come join %handle playing %streamGame_ [ $+ [ $mid($1,2) ] ] $+ . http://twitch.tv/ $+ $mid($1,2)
    var %encodedtweet = https://twitter.com/intent/tweet?text= $+ $urlencode(%autotweet_ [ $+ [ $mid($1,2) ] ])
    var -g %tweet_ [ $+ [ $mid($1,2) ] ] $tinyurl(%encodedtweet)
    msg $1 /me - AutoGen CTT: %tweet_ [ $+ [ $mid($1,2) ] ]
    .timer[CTT_ [ $+ [ $1 ] ] $+ ] 0 3600 msg $1 /me - Consider tweeting the stream to get more people in here to enjoy the show! %tweet_ [ $+ [ $mid($1,2) ] ]
  }
}
