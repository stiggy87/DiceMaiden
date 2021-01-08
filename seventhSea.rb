require 'pp'

class Array
  def contains_all? other
    other = other.dup
    each{|e| if i = other.index(e) then other.delete_at(i) end}
    other.empty?
  end

  def combine(prods)
    prods.map(&:flatten)
         .each_with_object(Hash.new {|h,k| h[k]=[]}) { |(k,v),h| h[k] << v }
         .map { |k,v| { k=>v } }
  end
end

def roll()
    (rand(10)).floor + 1
end

def rollNDice(count)
    rolls = []
    (1..count).each do |i|
        rolls.push(roll())
    end
    return rolls
end

# test6rolls = rollNDice(6) #[8, 1, 7, 5, 9, 2]  #[9, 9, 1, 2, 2, 10]  #[5, 3, 4, 10, 4, 6]
# print "#{test6rolls}\n"

rollCounts = Hash.new 0

def getRollCounts(roll)
    rollCounts = Hash.new 0
    roll.each do |die|
        rollCounts[die] += 1
    end
    return rollCounts
end
# print "Roll counts: #{rollCounts}\n"

# Count all the Tens
def getCritTen(roll)
    critTen = roll.select{|e| e == 10} 
    removedTens = roll.delete_if{|e| e == 10} 

    # return nonTenRoll
    return critTen, removedTens
end
# puts critTen
# Remove the 10's from the roll, and use the subset roll
# nonTenRoll = test6rolls.delete_if{|e| e == 10}
# print "#{nonTenRoll}\n"

# Find all permutations of exact Tens
# Start with exact Tens (x+y==10)
# Increase to (x+y=11), etc up to 18 (9+9)
# Loop through remaining roll

def getValidPerms(roll)
    validPerms = []
    # print "Max Permutations: #{(nonTenRoll.length/2 +1)}\n"
    (2..(roll.length/2 +1)).each do |i|

        # Loop through permutations starting with 2 (1 perms are perfect 10s)
        # print "Permutation: #{i}\n"
        roll.combination(i).to_a.each do |j|
            # print "#{j}\n"

            if(j.reduce(:+) >= 10)
                validPerms.push(j)
            end
        end
    end

    return createPermHash(validPerms)
end

def getValidPerms15(roll)
    validPerms = []
    # print "Max Permutations: #{(nonTenRoll.length/2 +1)}\n"
    (2..(roll.length/2 +1)).each do |i|

        # Loop through permutations starting with 2 (1 perms are perfect 10s)
        # print "Permutation: #{i}\n"
        roll.combination(i).to_a.each do |j|
            # print "#{j}\n"

            if(j.reduce(:+) >= 15)
                validPerms.push(j)
            end
        end
    end

    return createPermHash15(validPerms)
end


# print "Valid Permutations: #{validPerms}\n"

def createPermHash(validPerms)
    permHash = Hash.new 0
    (10..18).each do |val|
        permHash[val] = (validPerms.select {|e| e.reduce(:+) == val}).uniq
    end
    return permHash
end

def createPermHash15(validPerms)
    permHash = Hash.new 0
    (10..20).each do |val|
        permHash[val] = (validPerms.select {|e| e.reduce(:+) == val}).uniq
    end
    return permHash
end

# pp permHash

# Loop through valid perms and decrement the hash value
def calculateRaises(permHash, nonTenRoll, rollCounts)
    finalRoll = []
    permHash.each do |k,v|
        v.each do |i|
            i.each_slice(i.length) do |e|
                if(nonTenRoll.contains_all?(e))
                    finalRoll.push(e) # Push the pair in
                    e.each do |j|
                        next if (rollCounts[j] <= 0)
                        rollCounts[j] -= 1 
                        nonTenRoll.slice!(nonTenRoll.index(j))
                    end
                end
            end
        end

        # pp permHash
    end

    return finalRoll, nonTenRoll
end

def calculateRaises15(permHash, roll15, rollCounts)
    finalRoll = []
    permHash.each do |k,v|
        v.each do |i|
            i.each_slice(i.length) do |e|
                if(roll15.contains_all?(e))
                    finalRoll.push(e) # Push the pair in
                    e.each do |j|
                        next if (rollCounts[j] <= 0)
                        rollCounts[j] -= 1 
                        roll15.slice!(roll15.index(j))
                    end
                end
            end
        end

        # pp permHash
    end

    return finalRoll, roll15
end

# Remove the pair from the roll

# print "Roll counts Update : #{rollCounts}\n"
# print "Final Roll: #{finalRoll}\n"
# print "Remaining Rolls: #{nonTenRoll}\n"

# _tally = [10, 10, 10, 7, 1, 1]
# originalRoll = "[10, 7, 4, 3, 3, 2, 2, 2], [5]" #[10, 9, 9, 8, 6, 4] #[9, 6, 5, 4, 4, 1] 
# _tally  = [10, 8, 7, 7, 4, 2] #[10, 9, 9, 8, 6, 4] #[9, 6, 5, 4, 4, 1] #[5, 2, 1, 1, 2, 3] # What if a roll has no 15's? Count ten's
# explosions = []
# explosions = originalRoll.gsub(/.*,\s\[/,'') # Agreed limit is 5
# explosions = explosions.gsub(/\]/,'')
# explosions = explosions.split(",").map(&:to_i)
# # print "#{@tally} -- Explosion #{explosions}"
# explosions = explosions.sample(5) # Force the explosions to 5

# # Add explosions to tally and run Skill 4 then Skill 3
# _tally += explosions
# p _tally
# #_tally = rollNDice(6)

# rollCounts = getRollCounts(_tally)

# # # If Skill 4, then skip this
# # critTen, nonTenRoll = getCritTen(_tally)

# # permHash = Hash.new 0
# # permHash = getValidPerms(_tally)

# # finalRoll, nonTenRoll = calculateRaises(permHash, nonTenRoll, rollCounts)

# # finalRoll.push(critTen)
# # finalRoll.delete_if &:empty?
# # leftover = nonTenRoll
# # raises = finalRoll.length + (critTen.length > 1 ? critTen.length : 0)

# # p "#{@user} Rolls: `#{_tally}` and gets Raises: `#{raises}` from Groups: #{finalRoll} with leftover: #{leftover}"



# permHash = getValidPerms15(_tally)
# raises = 0
# finalRoll, roll = calculateRaises15(permHash, _tally, rollCounts)

# finalRoll.delete_if &:empty?
# leftover = roll
# raises15 = finalRoll.length*2

# if(raises == 0 || raises15= 0|| leftover.reduce(:+) >=10 ) # If raises are 0, run the 10's algorithm

#     critTen, nonTenRoll = getCritTen(_tally)

#     permHash = Hash.new 0
#     permHash = getValidPerms(_tally)

#     finalRoll10, nonTenRoll = calculateRaises(permHash, nonTenRoll, rollCounts)

#     finalRoll10.push(critTen)
#     finalRoll10.delete_if &:empty?
#     finalRoll += finalRoll10
#     finalRoll.delete_if &:empty?
#     leftover = nonTenRoll

#     raises = raises15 + finalRoll10.length + (critTen.length >= 1 ? critTen.length : 0)

#     p "#{@user} Rolls: `#{originalRoll}` and gets Raises: `#{raises}` from Groups: #{finalRoll} with leftover: #{leftover}"
# else
#     p "#{@user} Rolls: `#{originalRoll}` and gets Raises: `#{raises}` from Groups: #{finalRoll} with leftover: #{leftover}"
# end

# Skill 3 change
#_tally = [10, 10, 10, 8, 6, 6, 3, 2] #should be 5 raises not 6
# origRoll = _tally.clone
# rollCounts = getRollCounts(_tally)

# critTen, nonTenRoll = getCritTen(_tally)

# permHash = Hash.new 0
# permHash = getValidPerms(_tally)

# finalRoll, nonTenRoll = calculateRaises(permHash, nonTenRoll, rollCounts)

# p critTen
# p finalRoll
# p finalRoll + critTen
# finalRoll += critTen
# # finalRoll.delete_if &:empty?
# p finalRoll
# leftover = nonTenRoll

# raises = finalRoll.length# + (critTen.length >= 1 ? critTen.length : 0)

# p "Rolls: `#{origRoll}` and gets Raises: `#{raises}` from Groups: #{finalRoll} with leftover: #{leftover}"