class Category < ApplicationRecord
  # Self-referential association for nested categories
  belongs_to :parent_category, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_category_id', dependent: :destroy
  
  # Validations
  validates :name, presence: true, uniqueness: { scope: :parent_category_id }
  validate :cannot_be_parent_of_itself
  validate :cannot_have_circular_reference
  
  # Scopes
  scope :root_categories, -> { where(parent_category_id: nil) }
  scope :with_subcategories, -> { includes(:subcategories) }
  
  # Methods
  def root?
    parent_category_id.nil?
  end
  
  def leaf?
    subcategories.empty?
  end
  
  def depth
    return 0 if root?
    parent_category.depth + 1
  end
  
  def full_path
    return name if root?
    "#{parent_category.full_path} > #{name}"
  end
  
  def all_descendants
    descendants = []
    subcategories.each do |subcategory|
      descendants << subcategory
      descendants.concat(subcategory.all_descendants)
    end
    descendants
  end
  
  def all_ancestors
    ancestors = []
    current = parent_category
    while current
      ancestors << current
      current = current.parent_category
    end
    ancestors
  end
  
  private
  
  def cannot_be_parent_of_itself
    if parent_category_id.present? && parent_category_id == id
      errors.add(:parent_category_id, "cannot be parent of itself")
    end
  end
  
  def cannot_have_circular_reference
    if parent_category_id.present? && persisted? && all_ancestors.include?(self)
      errors.add(:parent_category_id, "would create a circular reference")
    end
  end
end
