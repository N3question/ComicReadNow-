class Public::UserRankingsController < ApplicationController
  
  # 可読情報に紐づいた読めた件数カラムのレコードの配列を取得
  def rank_index
    @comic_can_read = ReadableInfo.find(CanReadJudgement.group(:can_read).order('count(can_read) desc').pluck(:can_read))
  end
  
end