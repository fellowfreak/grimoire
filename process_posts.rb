SPELLS = %w[
Acid Splash
Blade Ward
Chill Touch
Dancing Lights
Fire Bolt
Light
Mage Hand
Message
Minor Illusion
Poison Spray
Prestidigitation
Ray of Frost
Shocking Grasp
True Strike
Color Spray
Comprehend Languages
Find Familiar
Fog Cloud
Grease
Ray of Sickness
Silent Image
Sleep
Tasha's Hideous Laughter
Unseen Servant
Witch Bolt
Mirror Image
Phantasmal Force
Arcane Lock
Blur
Crown of Madness
Darkness
Detect Thoughts
Enlarge/Reduce
Gust of Wind
Hold Person
Invisibility
Levitate
Misty Step
Rope Trick
Suggestion
Fear
Fireball
Haste
Leomund's Tiny Hut
Lightning Bolt
Sleet Storm
Slow
Vampiric Touch
Phantasmal Killer
Blight
Confusion
Ice Storm
Animate Objects
Telekinesis
Dominate Person
Geas
Mislead
Modify Memory
Passwall
Rary's Telepathic Bond
Seeming
Transportation Circle
Wall of Force
Antilife Shell
Contingency
Disintegrate
Eyebite
Flesh to Stone
Magic Jar
Mass Suggestion
Otto's Irresistible Dance
Mirage Arcane
Project Image
Reverse Gravity
Symbol
Teleport
Dominate Monster
Feeblemind
Gate
Imprisonment
Weird
]

SCHOOLS = %w[
  abjuration
  conjuration
  divination
  enchantment
  evocation
  illusion
  necromancy
  transmutation
]

LEVELS = %w[
  cantrip
  level1
  level2
  level3
  level4
  level5
  level6
  level7
  level8
  level9
]
DELIM = "\t"

headers = %w[Name School Level Ritual? SpellAttack? CastingTime Range Components Concentration Duration Description]
puts headers.join(DELIM)

def rewrite_school(s)
  # fixing school tags
  f = File.open("_posts/"+filename, 'w')
  contents.each do |line|
    if line =~ /^tags:/
      # if line =~ /#{spell_school}/i
      #   next
      # end

      SCHOOLS.each do |school|
        if line =~ /#{school}/i
          puts school + " -> " + s
          line = line.gsub!(school, s)
        end
      end
    end

    f.puts line
  end
end

def print_csv
  Dir.foreach("_posts") do |filename|
    spell_school = ""
    name = ""
    level = ""
    ritual = ""
    spell_attack = ""
    casting_time = ""
    range = ""
    components = ""
    concentration = ""
    duration = ""
    description = ""

    if filename == "." || filename == ".."
      next
    end
    # printf filename
    contents = File.readlines("_posts/"+filename)

    contents.each do |line|
      if line =~ /^title:\s*"(.*)"$/
        name = $1
        # printf name + DELIM
      end

      # if !SPELLS.include?(name)
      #   puts name
      #   break
      # end

      if line =~ /^\*\*.*level.*\*\*/i || line =~ /^\*\*.*cantrip.*\*\*/i
        SCHOOLS.each do |school|
          if line =~ /#{school}/i
            spell_school = school
            # printf school + DELIM
          end
        end

        if line =~ /cantrip/i
          level = 0
        elsif line =~ /(\d)/
          level = $1
        end

        if line =~ /ritual/i
          ritual = "true"
        end
      end

      if line =~ /^\*\*Casting Time\*\*: (.*)$/i
        casting_time = $1
      end

      if line =~ /^\*\*Range\*\*: (.*)$/i
        range = $1
      end

      if line =~ /^\*\*Components\*\*: (.*)$/i
        components = $1
      end

      if line =~ /^\*\*Duration\*\*: (.*)$/i
        duration = $1
        if line =~ /concentration/i
          concentration = "true"
        end
      end

      if line !~ /^\s*$/ &&
          line !~ /^---$/ &&
          line !~ /^\*\*/ &&
          line !~ /^layout:/ && line !~ /^title:/ && line !~ /^date:/ && line !~ /^tags:/
        description = description + " " + line.chomp
      end

      # if line =~ /make a (.*) spell attack/
      if description =~ /make a (.*) spell attack/i
        spell_attack = $1
      end

    end

    # rewrite_school(spell_school)
    values = [name, spell_school, level, ritual, spell_attack, casting_time, range, components, concentration, duration, description]
    puts values.join(DELIM)
  end
end

print_csv
