command: """
    zenbar/network.sh
"""
refreshFrequency: 5000

style: """
  -webkit-font-smoothing: antialiased
  color: #eee8d5
  font: 11px Hack
  top: 3px
  left: 5px
  span
    color: #777777
"""

render: -> """
  down
  <span class="down"></span>
  up
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

    lines = output.split "^"

    downBytes = (Number) lines[0]
    upBytes = (Number) lines[1]

    totalBytes = downBytes + upBytes

    updateStat 'down', downBytes, totalBytes
    updateStat 'up', upBytes, totalBytes

