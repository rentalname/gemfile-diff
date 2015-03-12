#!/usr/bin/env ruby
class Diff
  attr_reader :append, :delete

  def initialize
    @delete = {}
    @append = {}
  end

  def parse(line)
    line.chomp!.strip!
    if    line =~ /^\+\s*([\w-]+)\s\(([\d\.]+)\)/
      append_set($1, $2)
    elsif line =~ /^-\s*([\w-]+)\s\(([\d\.]+)\)/
      delete_set($1, $2)
    end
  end

  def report
    change_set = []

    change_set << "***** CHANGED GEM'S *****"
    (append.keys & delete.keys).each do |k|
      change_set << "#{k} #{append[k]}(was #{delete[k]})"
    end

    change_set << "\n***** INSTALLED GEM'S *****"
    (append.keys - delete.keys).each do |k|
      change_set << "#{k} #{append[k]}"
    end

    change_set << "\n***** UNINSTALLED GEM'S *****"
    (delete.keys - append.keys).each do |k|
      change_set << "#{k} #{delete[k]}"
    end

    change_set.each do |set|
      puts set
    end
  end

  def append_set(name, version)
    append[name] = version
  end

  def delete_set(name, version)
    delete[name] = version
  end

end

diff = Diff.new
ARGF.each_line do |line|
  diff.parse(line)
end

diff.report
