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
        if counter > 4 and counter < 9:
            background.append(bar)
        
        collect = audio.AudioQuantumList()
        
        collect.append(bar)
        
        out = audio.getpieces(audiofile, collect)        
        this_filename = "%s%d.mp3" % (output_filename, counter)
        
        sounds.append((bar, relevent_segment, "%s" % this_filename))
        
        out.encode(this_filename)
        
        if counter == 80:
            break
    
    background_out = audio.getpieces(audiofile, background)
    background_out.encode("background.mp3") 
    
    luacode_output(output_filename, sounds)

    #config_output(output_filename, sounds)
    
        
    
    """
    loudness_min = float(1000000)
    loudness_average = float(0)
    loudness_max = float(-100)
    
    duration_min = float(10000000)
    duration_max = float(-100)
    duration_average = float(0)
    
    for segment in segments:
        counter += 1
        
        loudness_average += segment.loudness_max
        
        if segment.loudness_max < loudness_min:
            loudness_min = segment.loudness_max
        
        if segment.loudness_max > loudness_max:
            loudness_max = segment.loudness_max
        
        duration_average += segment.duration
        
        if segment.duration < duration_min and segment.duration > 0:
            duration_min = segment.duration
        
        if segment.duration > duration_max:
            duration_max = segment.duration
            
            
    loudness_average = loudness_average / counter
    duration_average = duration_average / counter
    
    print "Max Duration: %d" % duration_max
    print "Min Duration: %d" % duration_min
    print "Ave Duration: %d" % duration_average
    print "Max Loudness: %d" % loudness_max
    print "Min Loudness: %d" % loudness_min
    print "Ave Loudness: %d" % loudness_average
    """



def luacode_output(output_filename, sounds):
    f = open("%s.ping.lua" % output_filename, 'w')
    
    f.write('function load_bricks()\n')
    
    loudness_total = float(0)
    loudness_min = float(1000000)
    loudness_max = float(-100000)
    
    count = 0
    
    for sound in sounds:
        
        count +=1
        
        bar = sound[0]
        segment = sound[1]
        filename = sound[2]
        
        print "Bar %d max loudness %f" % (count, segment.loudness_max)

        loudness_total += segment.loudness_max
        
        if segment.loudness_max < loudness_min:
            loudness_min = segment.loudness_max
        
        if segment.loudness_max > loudness_max:
            loudness_max = segment.loudness_max
        
        f.write("\tbrick_%s = love.audio.newSource('%s', 'static')\n" % (filename.split(".")[0], filename))
    
    loudness_average = float(loudness_total / float(count))
 
    print "Average Loudness: %f" % loudness_average
    print "Max Loudness: %f" % loudness_max
    print "Min Loudness: %f" % loudness_min
    
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
    for sound in sounds:
        
        bar = sound[0]
        segment = sound[1]
        filename = sound[2]
        
        f.write("\t\t{ exists = true, x = %d, y = %d, width = 100, height = 20, snd = brick_%s, r=%d, g=%d, b=%d },\n" % (col * 100, row * 20, filename.split(".")[0], colors[color_counter][0], colors[color_counter][1], colors[color_counter][2]))
        
        col += 1
        if col >= 8:
            col=0
            row +=1
            
        color_counter += 1
        if (color_counter >= len(colors)):
            color_counter = 0              
        
    f.write("\t }\n")
    f.write("end\n")
    """
    f.write('function load_state()\n')
    f.write("\treturn { \n")
    f.write("\t\t{ }")
    f.write("end\n")


    
    f2 = open("%s.ping.lua" % output_filename, 'w')
    """

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
