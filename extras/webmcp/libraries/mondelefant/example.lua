#!/usr/bin/env lua
mondelefant = require("mondelefant")

-- Standarddatenbankverbindung ist globale Variable 'db'
function mondelefant.class_prototype:get_db_conn() return db end

-- Verbindung aufbauen
db = assert(mondelefant.connect{engine='postgresql', dbname='test'})

Product = mondelefant.new_class{ table = "product" }
ProductVariant = mondelefant.new_class{ table = "product_variant" }

Product:add_reference{
  mode     = "1m",
  to       = ProductVariant,
  this_key = "number",
  that_key = "product_number",
  ref      = "product_variants",
  back_ref = "product",
  --default_order = '"number"'
}

ProductVariant:add_reference{
  mode     = "m1",
  to       = Product,
  this_key = "product_number",
  that_key = "number",
  ref      = "product",
  back_ref = nil,
  --default_order = '"id"'
}

p = Product:new_selector():single_object_mode():add_where{"name=?", "Noodles"}:exec()


--[[
-- Neue Datenbankklasse definieren
Product = mondelefant.new_class{ table = '"product"' }

-- Methode der Klasse, um sofort eine alphabetische Liste aller Produkte
-- zu bekommen
function Product:get_all_ordered_by_name()
  local selector = self:new_selector()
  selector:add_order_by('"name"')
  selector:add_order_by('"id"')
  return selector:exec()
end

function Product.object_get:name_length(key)
  local value = #self.name
  self._data.name_length = value
  return value
end

function Product.object_set:quality(value)
  if value == "perfect" or value == "good" or value == "trash" then
    self._data.quality = value
  else
    self._data.quality = nil
  end
  self._dirty.quality = true
end

-- Methode der Listen, um sie auszugeben
function Product.list:print()
  for i, product in ipairs(self) do
    print(product.id, product.name, product.name_length)
  end
end

products = Product:get_all_ordered_by_name()
products:print()
products[1].quality = "perfect"
print(products[1].quality)
products[2].quality = "I don't know."
print(products[2].quality)
products[3].name = "Produkt Eins!"
products[3].quality = "perfect"
products[3]:save()

sel = db:new_selector()
sel:from('"product_variant"')
sel:add_field("*")
sel:attach("m1", products, "product_id", "id", "product", "product_variants")
product_variants = sel:exec()
--]]
