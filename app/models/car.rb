class Car < ActiveRecord::Base
  belongs_to :make

  validates :make_id, :presence => true
  validates :model, :presence => true
  validates :color, :presence => true
  validates :date_listed, :presence => true
  validates :price, :presence => true
  validates :year, :presence => true

  def self.monthly_report(year)
    if year.nil?
      year = Time.now.year
    end

    # only get cars within this year
    cars = where("TO_CHAR(date_sold, 'YYYY') = '#{year}'")

    # Merge all dates for a given month in to day 1 of that month
    cars = cars.select "DATE('#{year}-' || TO_CHAR(date_sold, 'MM') || '-01') AS date_sold"

    cars = cars.select('make_id')
    cars = cars.select('avg(price) AS price')

    cars = cars.group('date_sold, make_id')
  end
end
