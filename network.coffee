command: """
    sar -n DEV 1 1 2> /dev/null |
    grep '[0-9].*en[0-9]' |
    {
    while read -r line;
    do
        downBytes=$(($downBytes + $(echo $line | awk '{down=$4} END {print down}')));
        upBytes=$(($upBytes + $(echo $line | awk '{up=$6} END {print up}')));
        result=$(echo "$downBytes $upBytes");
    done
    echo $result;
    }
"""
refreshFrequency: 3000

style: """
  -webkit-font-smoothing: antialiased
  color: #eee8d5
  font: 10px Hack
  top: 5px
  right: 245px
  span
    color: #777777
"""

render: -> """
  net
  <span class="down"></span>
  <span class="up"></span>
"""

update: (output, domEl) ->

    usage = (bytes) ->
        kb = bytes / 1024
        usageFormat kb

    usageFormat = (kb) ->
        if kb > 1024
            mb = kb / 1024
            "#{parseFloat(mb.toFixed(1))} MB/s"
        else
            "#{parseFloat(kb.toFixed(2))} KB/s"

    updateStat = (sel, currBytes, totalBytes) ->
        percent = (currBytes / totalBytes * 100).toFixed(1) + "%"
        $(domEl).find(".#{sel}").text usage(currBytes)
        $(domEl).find(".bar-#{sel}").css "width", percent

    lines = output.split " "

    downBytes = (Number) lines[0]
    upBytes = (Number) lines[1]

    totalBytes = downBytes + upBytes

    updateStat 'down', downBytes, totalBytes
    updateStat 'up', upBytes, totalBytes

