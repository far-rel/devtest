require 'test_helper'

class TargetGroupTest < ActiveSupport::TestCase

  test 'cycles are not allowed' do
    parent = target_groups(:parent)
    parent.parent_id = target_groups(:child).id
    refute parent.save
  end

  test 'parent can\'t be self' do
    parent = target_groups(:parent)
    parent.parent_id = parent.id
    refute parent.save
  end

  test '#all_descendant_ids returns array of ids' do
    parent = target_groups(:parent)
    assert parent.all_descendant_ids == [target_groups(:child).id, target_groups(:child_2).id, target_groups(:child_3).id]
  end

  test '#all_descendant_ids returns empty array on leaf node' do
    leaf = target_groups(:child_2)
    assert leaf.all_descendant_ids == []
  end

  test '.groups_for_county returns all groups with the same panel provider belonging to county' do
    result = TargetGroup.groups_for_country(countries(:pl).code)
    assert result == [target_groups(:parent), target_groups(:child)]
  end

end
