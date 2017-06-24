#!/perl/bin/ruby -Ku
# -*- coding: utf-8 -*-

require 'kconv'
require 'fileutils'
require 'configBcDice.rb'

# extratables ディレクトリに置かれたテーブル定義ファイルを読み込む。
# 詳細はREADME.txtの「７．オリジナルの表追加」を参照。
# 
# 定義ファイルの内容を @tableData として保持する。
# この @tableData は
# 
# @tableData : {
#   コマンド : {
#          "fileName" : (表ファイル名),
#          "title" : (表タイトル),
#          "command" : (コマンド文字),
#          "gameType" : (ゲーム種別),
#          "dice" : (ダイス文字),
#          "table" : {
#            (数値) : (テキスト),
#            (数値) : (テキスト),
#            (数値) : (テキスト),
#          }
#   }
# }
# 
# というデータフォーマットとなる。


class TableFileData
  
  def initialize(isLoadCommonTable = true)
    @dirs = []
    @tableData = Hash.new
    
    return unless( isLoadCommonTable )
    
    @dir = FileTest.directory?('./extratables') ? './extratables' : '../extratables'
    @tableData = searchTableFileDefine(@dir)
  end
  
  def setDir(dir, prefix = '')
    return if( @dirs.include?(dir) )
    @dirs << dir
    
    tableData = searchTableFileDefine(dir, prefix)
    @tableData.merge!( tableData )
  end
  
  def searchTableFileDefine(dir, prefix = '')
    tableData = Hash.new
    
    return tableData if( dir.nil? )
    return tableData if( not File.exist?(dir) )
    return tableData if( not File.directory?(dir) )
    
    fileNames = Dir.glob("#{dir}/#{prefix}*.txt")
    
    fileNames.each do |fileName|
      fileName = fileName.untaint
      
      info = readGameCommandInfo(fileName, prefix)
      gameType = info["gameType"]
      gameType ||= ""
      command = info["command"]
      next if(command.empty?)
      
      tableData["#{gameType}_#{command}"] = info
    end
    
    return tableData
  end
  
  
  def readGameCommandInfo(fileName, prefix)
    info = {
      "fileName" => fileName,
      "gameType" => '',
      "command" => '',
    }
    
    baseName = File.basename(fileName, '.txt')
    
    case baseName
    when /^#{prefix}(.+)_(.+)_(.+)$/
      info["command"] = $3
      info["gameType"] = $1 + ":" + $2
    when /^#{prefix}(.+)_(.+)$/
      info["command"] = $2
      info["gameType"] = $1
    when /^#{prefix}(.+)$/
      info["command"] = $1
      info["gameType"] = ''
    end
    
    return info
  end
  
  
  def getAllTableInfo
    result = []
    
    @tableData.each do |key, oneTableData|
      tableData = readOneTableData(oneTableData)
      result << tableData
    end
    
    return result
  end
  
  def getGameCommandInfos
    commandInfos = []
    
    @tableData.each do |command, info|
      commandInfo = {
        "gameType" => info["gameType"],
        "command" => info["command"],
      }
      
      commandInfos << commandInfo
    end
    
    return commandInfos
  end
  
  
  def getTableDataFromFile(fileName)
    table = []
    lines = File.read(fileName).toutf8.lines.map(&:chomp)
    
    defineLine = lines.shift
    dice, title = getDiceAndTitle(defineLine)
    
    lines.each do |line|
      key, value = getLineKeyValue(line)
      next if( key.empty? )
      
      key = key.to_i
      table << [key, value]
    end
    
    return dice, title, table
  end
  
  def getLineKeyValue(line)
    self.class.getLineKeyValue(line)
  end
  
  def self.getLineKeyValue(line)
    line = line.toutf8.chomp
    
    unless(/^[\s　]*([^:：]+)[\s　]*[:：][\s　]*(.+)/ === line)
      return '', ''
    end
    
    key = $1
    value = $2
    
    return key, value
  end
      
  
  def getDiceAndTitle(line)
    dice, title = getLineKeyValue(line)
    
    return dice, title
  end
  
  
  def getTableData(arg, targetGameType)
    oneTableData = Hash.new
    isSecret = false
    
    @tableData.keys.each do |fileName|
      next unless(/.*_(.+)/ === fileName)
      key = $1
      
      next unless(/^(s|S)?#{key}(\s|$)/i === arg)
      
      data = @tableData[fileName]
      gameType = data["gameType"]
      
      next unless( isTargetGameType(gameType, targetGameType) )
      
      oneTableData = data
      isSecret = (not $1.nil?)
      break
    end
    
    readOneTableData(oneTableData)
    
    dice  = oneTableData["dice"]
    title = oneTableData["title"]
    table = oneTableData["table"]
    
    table = changeEnterCode(table)
    
    return dice, title, table, isSecret
  end
  
  def changeEnterCode(table)
    newTable = {}
    if( table.nil? )
        return newTable
    end
    table.each do |key, value|
      value = value.gsub(/\\n/, "\n")
      value = value.gsub(/\\\n/, "\\n")
      newTable[key] = value
    end
    
    return newTable
  end
  
  
  def isTargetGameType(gameType, targetGameType)
    return true if( gameType.empty? )
    return ( gameType == targetGameType )
  end
  
  
  def readOneTableData(oneTableData)
    return if( oneTableData.nil? )
    return unless( oneTableData["table"].nil? )
    
    command = oneTableData["command"]
    gameType = oneTableData["gameType"]
    fileName = oneTableData["fileName"]
    
    return if( command.nil? )
    
    return if( not File.exist?(fileName) )
    
    dice, title, table  = getTableDataFromFile(fileName)
    
    oneTableData["dice"] = dice
    oneTableData["title"] = title
    oneTableData["table"] = table
    
    return oneTableData
  end
  
end
