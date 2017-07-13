require 'csv'
all = CSV.read('db/names.csv')
n = 0
m = rand(41)
o = 1
p = rand(41)
q = 2
r = rand(41)
s = 3
t = rand(41)
Rails.logger.info m
Rails.logger.info p
Rails.logger.info r
Rails.logger.info t
puts all[m][n]+" "+all[p][o]+" "+all[r][q]+" "+all[t][s]