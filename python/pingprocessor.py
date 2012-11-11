"""
pingprocessor.py

Takes as an input a song; outputs an initial game state for Ping game and chopped up sound clips.

By Jim Fingal 2012-11-10
"""
import sys

import echonest.audio as audio
import string

usage = """
Usage: 
    python pingprocessor.py <inputfilename>
    
Example:
    python pingprocessor.py Heresy.mp3
    
"""

def main(input_filename):
    
    output_filename = input_filename.split('.')[0]
    
    output_filename = ''.join(c for c in output_filename if c.isalnum())
    
    if output_filename == "":
        output_filename = "Untitled"
    
    
    sounds = []
    segments= []
    bricks = []
    
    audiofile = audio.LocalAudioFile(input_filename)   
    bars = audiofile.analysis.bars
    segments = audiofile.analysis.segments

    counter = 0
        
    background = audio.AudioQuantumList()

    for bar in bars:
        
        # Check to see if we are loud enough to generate bricks
      
        start = bar.start
        duration = bar.duration
        
        relevant_segment = None
        
        for segment in segments:
            if segment.start > start:
                if segment.start > start + duration:
                    break # Last segment
                else:
                    relevent_segment = segment
                    break
            relevant_segment = segment

        if relevant_segment.loudness_max < -25:
            continue
        
        counter += 1
        if counter < 5:
           background.append(bar)
        
        
        collect = audio.AudioQuantumList()
        
        collect.append(bar)
        
        out = audio.getpieces(audiofile, collect)        
        this_filename = "%s%d.mp3" % (output_filename, counter)
        
        sounds.append((bar, relevent_segment, "%s" % this_filename))
        
        out.encode(this_filename)
        
        if counter > 200:
            break    
    
    bc = 0
    
    extended_background = audio.AudioQuantumList()

    while bc < 20:
        bc +=1
        for bar in background:
            extended_background.append(bar)
            
    
    background_out = audio.getpieces(audiofile, extended_background)
    background_out.encode("%s_background.mp3" % output_filename) 
    
    luacode_output(output_filename, sounds, audiofile, background_out)


def luacode_output(output_filename, sounds, audiofile, background_out):
    f = open("%s.lua" % output_filename, 'w')
    
    f.write('function load_bricks()\n')
    
    total = float(0)
    min = float(1000000)
    max = float(-100000)
    
    count = 0
    
    sounds.reverse()
    
    for sound in sounds:
        
        count +=1
        
        bar = sound[0]
        segment = sound[1]
        filename = sound[2]
        
        feature_val = segment.timbre[1]
        
        #print "Bar %d max brightness %f" % (count, feature_val)

        total += feature_val
        
        if feature_val < min:
            min = feature_val
        
        if feature_val > max:
            max = feature_val
        
        f.write("\tbrick_%s = love.audio.newSource('%s', 'static')\n" % (filename.split(".")[0], filename))
    
    average = float(total / float(count))
 
    #print "Average Feature Value: %f" % average
    #print "Max Feature Value: %f" % max
    #print "Min Feature Value: %f" % min
    
    c1 = 205
    c2 = 147
    c3 = 176
    
    
    # 10 colors
    
    colors =[]
    colors.append((c1, c2, c2))
    colors.append((c1, c2, c3))
    colors.append((c1, c2, c1))
    colors.append((c3, c2, c1))
    colors.append((c2, c2, c1))
    colors.append((c2, c3, c1))
    colors.append((c2, c1, c1))
    colors.append((c2, c1, c3))
    colors.append((c2, c1, c2))
    colors.append((c3, c1, c2))
    # colors.append((c1, c1, c2))
    # colors.append((c1, c3, c2))
   

    color_counter = 0
    
    row = 0
    col = 0
    f.write("\treturn { \n")
    
    
    max_bricks_in_row = 8
    
    max_vert_pixels = 1200
    
    total_sounds = len(sounds)
    sound_counter = 0
    
    longrow = False
    offset = 0
        
    for sound in sounds:
        
        if row * 50 >= max_vert_pixels:
            break
        
        remaining = total_sounds - sound_counter
        sound_counter += 1
        
        if col == 0 and remaining < 7:
            offset = 400 - ((remaining * 100) / 2)

        elif longrow:
            offset = 0
        else:
            offset = 50
        
        bar = sound[0]
        segment = sound[1]
        filename = sound[2]
        
        brightness = segment.timbre[1]
        
        color_index = 0
        
        draw = True
        
        if brightness < 0:
            color_index = 9
        elif brightness < 20:
            color_index = 8
        elif brightness < 30:
            color_index = 7
        elif brightness < 40:
            color_index = 6
        elif brightness < 50:
            color_index = 5
        elif brightness < 60:
            color_index = 4
        elif brightness < 70:
            color_index = 3
        elif brightness < 80:
            color_index = 2
        elif brightness < 90:
            color_index = 1
        elif brightness > 100:
            color_index = 0
           
            
        if draw:
            f.write("\t\t{ exists = true, x = %d, y = %d, width = 100, height = 20, snd = brick_%s, r=%d, g=%d, b=%d, brightness_index=%d },\n" % ((col * 100) + offset, row * 20, filename.split(".")[0], colors[color_index][0], colors[color_index][1], colors[color_index][2], color_index))

        col += 1
        
        if col >= max_bricks_in_row and longrow:
            col=0
            row+=1
            longrow = False
            continue
        elif col >= max_bricks_in_row - 1 and not longrow:
            col=0
            row+=1   
            longrow = True
          
        
    f.write("\t }\n")
    f.write("end\n")
    
    speed = audiofile.analysis.tempo['value'] * audiofile.analysis.tempo['confidence'] 
    
    default_x = 100
    default_y = 475
        
    x = default_x + (speed - 110)
    y = default_y  + (speed - 110)
    
    if x < 5:
        x = 5
    
    if y < 10:
        y = 10
    
    f.write('function load_state()\n')
    f.write("\treturn { ball_x=%d, ball_y=%d}\n" % (x, y))
    f.write("end\n")
    f.write('function load_loop()\n')
    f.write('\tbackground_snd = love.audio.newSource("%s_background.mp3", "static")\n' % output_filename)
    f.write('\tbackground_snd:setVolume(0.25)\n')
    f.write('\tbackground_snd:setLooping(true)\n')
    f.write('\tbackground_length = %s\n' % background_out.duration)
    f.write('\tsong_length = %s\n' % audiofile.duration)
    f.write('\tlove.audio.play(background_snd)\n')
    f.write('end\n')
    
def dump(obj):
    for attr in dir(obj):
        print "obj.%s = %s" % (attr, getattr(obj, attr))

if __name__ == '__main__':
    try:
        input_filename = sys.argv[1]
     
    except:
        print usage
        sys.exit(-1)
   
    main(input_filename)
