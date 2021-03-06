class Main
     
     drawBones:(data)=>
          for x in data.bones
               if x['hand_left']['x'] != 0
                    for joint of x
                         @ctx.beginPath()
                         x_pos = 512 + (x[joint]['x'] * 500)
                         y_pos = 384 + -x[joint]['y'] * 500
                         @ctx.arc(x_pos,  y_pos, 10 * x[joint]['z'], 0, 2*Math.PI )
                         @ctx.fill()
                         if joint == 'head'
                              head = $("#hulk_mask")[0]
                              @ctx.drawImage(head, x_pos - 50, y_pos - 50, 100, 100)
     
     deviceReady: (data)=>
          @getJoints()
          
          
          if data.rgb
               image_data = 'data:image/jpg;base64,'+data.rgb
               img = new Image()
               img.onload = =>
                    @ctx.clearRect 0, 0, 1024, 768
                    @ctx.drawImage(img, 0, 0, 1024, 768)
                    @drawBones(data)
               img.src = image_data
          else
               @ctx.clearRect 0, 0, 1024, 768
               @drawBones(data)

     getJoints:=>
          $.ajax
               url: 'http://localhost:8080'
               dataType: 'jsonp'
               jsonpCallback: 'jsonCallback'
               jsonp: 'callback'
     
     constructor:->
          @can = $("canvas")[0]
          @can.width = 1024
          @can.height = 768
          @ctx = @can.getContext("2d")
          
          window.jsonCallback = @deviceReady

          @getJoints()


$(document).ready ->
     new Main()