#!/usr/bin/env ruby

@joint_list = {
  0   => "Neck",
  1   => "Chest",
  2   => "Lumbar",
  3   => "Abs",
  4   => "Right pec",
  5   => "Right shoulder",
  6   => "Right elbow",
  7   => "Left pec",
  8   => "Left shoulder",
  9   => "Left elbow",
  10  => "Right wrist",
  11  => "Left wrist",
  12  => "Right glute",
  13  => "Left glute",
  14  => "Right hip",
  15  => "Left hip",
  16  => "Right knee",
  17  => "Left knee",
  18  => "Right ankle",
  19  => "Left ankle"
}

@joint_states = {
  1 => ["Extend", "Lower", "Right Rotate", "Right Bend"],
  2 => ["Contract", "Raise", "Left Rotate", "Left Bend"],
  3 => "Hold",
  4 => "Relax"
}


def state_of_joint(state, joint)
  return @joint_states[state] if state == 3 || state == 4
  
  case joint
  when 1: # rotate (neck)
    return @joint_states[state][2]    
  when 2: # bend (lumbar)
    return @joint_states[state][3]    
  when 5,8: # lower/raise (shoulder)
    return @joint_states[state][1]
  when 12,13,14,15: # extend/contract reversed
    return @joint_states[((state == 1) ? 2 : 1)][0]
  else
    return @joint_states[state][0]
  end
end

replay = STDIN.read

@players = {}
replay.each_line do |line|
  case line
  when /BOUT (\d+); (.+)$/
    @players[$1.to_i] = $2
  when /^FRAME (\d+)/:
    puts "Frame: #{$1.to_i}\n"
  when /^GRAB/
  when /^JOINT (0|1); (.*)$/
    puts "\tPlayer: #{@players[$1.to_i] || $1.to_i}"
    $2.scan(/\d+\s+\d+/).map {|p| p.split(/\s+/)}.each do |(joint, state)|
      puts "\t\t#{state_of_joint(state.to_i, joint.to_i)} #{@joint_list[joint.to_i]}\n"
    end
  end
end