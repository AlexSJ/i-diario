class StandardizeTeachingPlansContents < ActiveRecord::Migration
  def change
    rename_column :teaching_plans, :content, :old_contents
    TeachingPlan.all.each do |teaching_plan|
      teaching_plan.contents = teaching_plan.old_contents.split(/\s*[,;]\s* | [\r\n]+ /x).map(&:strip!).reject(&:blank?).map{|v| Content.find_or_create_by!(description: v)}
      teaching_plan.save!
    end
  end
end
