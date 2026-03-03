"""
Demo seed — inserts realistic Canadian grocery data so you can test the full app
without needing live scraper access.

Includes ~20 common products priced at 8 stores across 4 chains in Toronto/GTA.
Run:  python seed_demo.py
"""
import asyncio
import uuid
from datetime import datetime, timezone

async def main():
    from app.database import engine, Base, AsyncSessionLocal
    import app.models  # ensure models registered

    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    from app.models import Product, Store, Price

    # ── stores ────────────────────────────────────────────────────────────────
    stores_data = [
        dict(store_id="lob-1012", chain="loblaws",  banner="Loblaws",                    name="Loblaws Maple Leaf Gardens", address="60 Carlton St",       city="Toronto",     province="ON", postal_code="M5B 1J2", lat=43.6618, lng=-79.3797),
        dict(store_id="lob-1035", chain="loblaws",  banner="No Frills",                  name="No Frills Broadview",        address="765 Broadview Ave",   city="Toronto",     province="ON", postal_code="M4K 2P5", lat=43.6762, lng=-79.3553),
        dict(store_id="lob-1089", chain="loblaws",  banner="Real Canadian Superstore",   name="RCSS Etobicoke",             address="900 Dixon Rd",        city="Etobicoke",   province="ON", postal_code="M9W 1J9", lat=43.7067, lng=-79.5683),
        dict(store_id="wmt-3124", chain="walmart",  banner="Walmart",                    name="Walmart Scarborough",        address="300 Borough Dr",      city="Scarborough",  province="ON", postal_code="M1P 4P5", lat=43.7762, lng=-79.2571),
        dict(store_id="wmt-3211", chain="walmart",  banner="Walmart",                    name="Walmart Mississauga",        address="5765 Mavis Rd",       city="Mississauga",  province="ON", postal_code="L5V 3A9", lat=43.5890, lng=-79.6582),
        dict(store_id="sob-2201", chain="sobeys",   banner="Sobeys",                     name="Sobeys Yonge & Eg",          address="2280 Yonge St",       city="Toronto",     province="ON", postal_code="M4P 2W4", lat=43.7069, lng=-79.3985),
        dict(store_id="sob-2318", chain="sobeys",   banner="FreshCo",                    name="FreshCo Weston",             address="2065 Lawrence Ave W", city="Toronto",     province="ON", postal_code="M9N 1H9", lat=43.7241, lng=-79.5118),
        dict(store_id="met-5501", chain="metro",    banner="Metro",                      name="Metro Bloor West",           address="2035 Bloor St W",     city="Toronto",     province="ON", postal_code="M6S 1M6", lat=43.6508, lng=-79.4836),
    ]

    # ── products ──────────────────────────────────────────────────────────────
    products_data = [
        # Beverages
        dict(upc="0055742412879", name="Tropicana Orange Juice 1.75L",           brand="Tropicana",    category="Beverages",       image_url=None),
        dict(upc="0062639015016", name="President's Choice Cola 2L",             brand="PC",           category="Beverages",       image_url=None),
        dict(upc="0069000007629", name="Tropicana Apple Juice 1.75L",            brand="Tropicana",    category="Beverages",       image_url=None),
        dict(upc="0055742410912", name="Minute Maid Apple Juice 1.89L",          brand="Minute Maid",  category="Beverages",       image_url=None),
        dict(upc="0064777030061", name="No Name Apple Juice 1L",                 brand="No Name",      category="Beverages",       image_url=None),
        dict(upc="0055742411919", name="Tropicana Grape Juice 1.75L",            brand="Tropicana",    category="Beverages",       image_url=None),
        dict(upc="0067553033022", name="Nestea Iced Tea 1.75L",                  brand="Nestea",       category="Beverages",       image_url=None),
        dict(upc="0069000018892", name="Minute Maid Orange Juice 2.63L",         brand="Minute Maid",  category="Beverages",       image_url=None),
        # Fresh Produce (bagged — these have UPCs; loose apples use PLU codes at the scale)
        dict(upc="0033383003039", name="Gala Apples 3lb Bag",                    brand=None,           category="Produce",         image_url=None),
        dict(upc="0033383003046", name="Granny Smith Apples 3lb Bag",            brand=None,           category="Produce",         image_url=None),
        dict(upc="0033383003053", name="Fuji Apples 3lb Bag",                    brand=None,           category="Produce",         image_url=None),
        dict(upc="0033383003060", name="Honeycrisp Apples 3lb Bag",              brand=None,           category="Produce",         image_url=None),
        dict(upc="0060224700032", name="PC Organics Gala Apples 2lb Bag",        brand="PC Organics",  category="Produce",         image_url=None),
        dict(upc="0033383005019", name="Bananas 3lb Bag",                        brand=None,           category="Produce",         image_url=None),
        dict(upc="0033383006019", name="Navel Oranges 4lb Bag",                  brand=None,           category="Produce",         image_url=None),
        dict(upc="0033383007016", name="Russet Potatoes 10lb Bag",               brand=None,           category="Produce",         image_url=None),
        dict(upc="0033383008013", name="Yellow Onions 3lb Bag",                  brand=None,           category="Produce",         image_url=None),
        dict(upc="0033383009010", name="Roma Tomatoes 1lb",                      brand=None,           category="Produce",         image_url=None),
        dict(upc="0033383010019", name="Seedless Grapes Red 2lb Bag",            brand=None,           category="Produce",         image_url=None),
        dict(upc="0033383011016", name="Strawberries 1lb",                       brand=None,           category="Produce",         image_url=None),
        # Dairy & Milk
        dict(upc="0058176510208", name="Natrel 2% Milk 4L",                      brand="Natrel",       category="Dairy",           image_url=None),
        dict(upc="0058176410102", name="Natrel Whole Milk 4L",                   brand="Natrel",       category="Dairy",           image_url=None),
        dict(upc="0064777040015", name="No Name Skim Milk 4L",                   brand="No Name",      category="Dairy",           image_url=None),
        dict(upc="0065684001038", name="Silk Almond Milk Original 1.89L",        brand="Silk",         category="Dairy Alt",       image_url=None),
        dict(upc="0065684001069", name="Silk Oat Milk Original 1.89L",           brand="Silk",         category="Dairy Alt",       image_url=None),
        dict(upc="0060383019655", name="Gay Lea Salted Butter 454g",             brand="Gay Lea",      category="Dairy",           image_url=None),
        dict(upc="0059749859502", name="Activia Strawberry Yogurt 8-pack",       brand="Danone",       category="Dairy",           image_url=None),
        dict(upc="0059749855818", name="Yoplait Source Vanilla Yogurt 650g",     brand="Yoplait",      category="Dairy",           image_url=None),
        dict(upc="0068826716011", name="Compliments Brown Eggs 12pk",            brand="Compliments",  category="Eggs",            image_url=None),
        dict(upc="0069700050021", name="Balderson Old Cheddar Cheese 400g",      brand="Balderson",    category="Dairy",           image_url=None),
        dict(upc="0064777052018", name="No Name Marble Cheddar 800g",            brand="No Name",      category="Dairy",           image_url=None),
        dict(upc="0072058210400", name="Kraft Mozzarella Shredded 320g",         brand="Kraft",        category="Dairy",           image_url=None),
        # Bakery & Bread
        dict(upc="0064777007019", name="Dempster's Whole Grain Bread 675g",      brand="Dempster's",   category="Bakery",          image_url=None),
        dict(upc="0064777005015", name="Dempster's White Bread 675g",            brand="Dempster's",   category="Bakery",          image_url=None),
        dict(upc="0064777005176", name="Dempster's 12-Grain Bread 600g",         brand="Dempster's",   category="Bakery",          image_url=None),
        dict(upc="0060224012018", name="PC Multigrain English Muffins 6pk",      brand="PC",           category="Bakery",          image_url=None),
        # Cereal & Breakfast
        dict(upc="0056920503413", name="Cheerios 520g",                          brand="General Mills",category="Cereal",          image_url=None),
        dict(upc="0038000596025", name="Kellogg's Corn Flakes 725g",             brand="Kellogg's",    category="Cereal",          image_url=None),
        dict(upc="0038000045714", name="Kellogg's Special K Original 540g",      brand="Kellogg's",    category="Cereal",          image_url=None),
        dict(upc="0064777058010", name="No Name Quick Oats 2kg",                 brand="No Name",      category="Cereal",          image_url=None),
        # Snacks
        dict(upc="0057000001217", name="Lay's Original Chips 200g",              brand="Lay's",        category="Snacks",          image_url=None),
        dict(upc="0028400064057", name="Doritos Nacho Cheese 255g",              brand="Doritos",      category="Snacks",          image_url=None),
        dict(upc="0064777025012", name="No Name Apple Chips 170g",               brand="No Name",      category="Snacks",          image_url=None),
        dict(upc="0055826000171", name="Ritz Crackers Original 200g",            brand="Ritz",         category="Snacks",          image_url=None),
        # Meat & Protein
        dict(upc="0066721009978", name="Kirkland Organic Chicken Breast 1kg",    brand="Kirkland",     category="Meat",            image_url=None),
        dict(upc="0060224610019", name="PC Free From Boneless Chicken 600g",     brand="PC",           category="Meat",            image_url=None),
        dict(upc="0068826001093", name="Compliments Extra Lean Ground Beef 1kg", brand="Compliments",  category="Meat",            image_url=None),
        dict(upc="0068826001512", name="Compliments Atlantic Salmon Fillet 500g",brand="Compliments",  category="Seafood",         image_url=None),
        # Produce
        dict(upc="0066721080018", name="Compliments Baby Carrots 2lb",           brand="Compliments",  category="Produce",         image_url=None),
        dict(upc="0068826320015", name="PC Organic Broccoli 340g",               brand="PC",           category="Produce",         image_url=None),
        dict(upc="0064777090011", name="No Name Frozen Strawberries 600g",       brand="No Name",      category="Frozen",          image_url=None),
        dict(upc="0064777091018", name="No Name Frozen Mixed Vegetables 750g",   brand="No Name",      category="Frozen",          image_url=None),
        # Condiments & Spreads
        dict(upc="0065633169013", name="Heinz Ketchup 1L",                       brand="Heinz",        category="Condiments",      image_url=None),
        dict(upc="0073735900116", name="Hellmann's Real Mayonnaise 890mL",       brand="Hellmann's",   category="Condiments",      image_url=None),
        dict(upc="0055825501318", name="Kraft Peanut Butter Smooth 1kg",         brand="Kraft",        category="Spreads",         image_url=None),
        dict(upc="0055825501325", name="Kraft Peanut Butter Crunchy 1kg",        brand="Kraft",        category="Spreads",         image_url=None),
        dict(upc="0064777028013", name="No Name Strawberry Jam 500mL",           brand="No Name",      category="Spreads",         image_url=None),
        # Grains, Pasta & Baking
        dict(upc="0067100780019", name="Uncle Ben's Long Grain Rice 2kg",        brand="Uncle Ben's",  category="Grains",          image_url=None),
        dict(upc="0078742018812", name="Barilla Spaghetti 900g",                 brand="Barilla",      category="Pasta",           image_url=None),
        dict(upc="0078742015002", name="Barilla Penne Rigate 900g",              brand="Barilla",      category="Pasta",           image_url=None),
        dict(upc="0064777006715", name="No Name All-Purpose Flour 10kg",         brand="No Name",      category="Baking",          image_url=None),
        dict(upc="0064777006043", name="No Name Granulated Sugar 2kg",           brand="No Name",      category="Baking",          image_url=None),
        # Coffee & Tea
        dict(upc="0025500072404", name="Folgers Classic Roast Coffee 920g",      brand="Folgers",      category="Coffee & Tea",    image_url=None),
        dict(upc="0065633481017", name="Nabob 100% Colombian Coffee 300g",       brand="Nabob",        category="Coffee & Tea",    image_url=None),
        dict(upc="0064777073015", name="No Name Orange Pekoe Tea 72pk",          brand="No Name",      category="Coffee & Tea",    image_url=None),
        # Canned & Pantry
        dict(upc="0064777043016", name="No Name Diced Tomatoes 796mL",           brand="No Name",      category="Canned",          image_url=None),
        dict(upc="0065633200018", name="Heinz Tomato Soup 284mL",                brand="Heinz",        category="Canned",          image_url=None),
        dict(upc="0064777044013", name="No Name Chickpeas 540mL",                brand="No Name",      category="Canned",          image_url=None),
        dict(upc="0064777045010", name="No Name Red Kidney Beans 540mL",         brand="No Name",      category="Canned",          image_url=None),
        # Household
        dict(upc="0068113197916", name="Ivory Dishwasher Pods 45ct",             brand="Ivory",        category="Household",       image_url=None),
        dict(upc="0037000941774", name="Tide Laundry Pods 31ct",                 brand="Tide",         category="Household",       image_url=None),
        dict(upc="0068826420013", name="Compliments Paper Towels 6pk",           brand="Compliments",  category="Household",       image_url=None),
        dict(upc="0068826430012", name="Compliments Bath Tissue 12pk",           brand="Compliments",  category="Household",       image_url=None),
    ]

    # ── prices (cents) — realistic variance across chains ─────────────────────
    # Format: (upc, store_id, price_cents, unit, on_sale, sale_price_cents)
    prices_data = [
        # Tropicana OJ 1.75L
        ("0055742412879","lob-1012", 749,"each",False,None),
        ("0055742412879","lob-1035", 699,"each",True, 649),
        ("0055742412879","lob-1089", 749,"each",False,None),
        ("0055742412879","wmt-3124", 689,"each",False,None),
        ("0055742412879","wmt-3211", 689,"each",False,None),
        ("0055742412879","sob-2201", 759,"each",False,None),
        ("0055742412879","sob-2318", 729,"each",False,None),
        ("0055742412879","met-5501", 769,"each",False,None),

        # Natrel Milk 4L
        ("0058176510208","lob-1012", 699,"each",False,None),
        ("0058176510208","lob-1035", 649,"each",False,None),
        ("0058176510208","lob-1089", 649,"each",False,None),
        ("0058176510208","wmt-3124", 639,"each",False,None),
        ("0058176510208","wmt-3211", 639,"each",False,None),
        ("0058176510208","sob-2201", 679,"each",False,None),
        ("0058176510208","sob-2318", 659,"each",True, 629),
        ("0058176510208","met-5501", 699,"each",False,None),

        # Gay Lea Butter
        ("0060383019655","lob-1012", 499,"each",False,None),
        ("0060383019655","lob-1035", 469,"each",True, 449),
        ("0060383019655","wmt-3124", 459,"each",False,None),
        ("0060383019655","wmt-3211", 459,"each",False,None),
        ("0060383019655","sob-2201", 509,"each",False,None),
        ("0060383019655","met-5501", 489,"each",False,None),

        # Dempster's Bread
        ("0064777007019","lob-1012", 499,"each",False,None),
        ("0064777007019","lob-1035", 449,"each",False,None),
        ("0064777007019","wmt-3124", 429,"each",False,None),
        ("0064777007019","wmt-3211", 429,"each",False,None),
        ("0064777007019","sob-2201", 489,"each",True, 459),
        ("0064777007019","sob-2318", 449,"each",False,None),
        ("0064777007019","met-5501", 479,"each",False,None),

        # Heinz Ketchup 1L
        ("0065633169013","lob-1012", 549,"each",False,None),
        ("0065633169013","lob-1035", 499,"each",False,None),
        ("0065633169013","wmt-3124", 479,"each",False,None),
        ("0065633169013","wmt-3211", 479,"each",False,None),
        ("0065633169013","sob-2201", 569,"each",True, 499),
        ("0065633169013","met-5501", 559,"each",False,None),

        # Cheerios
        ("0056920503413","lob-1012", 649,"each",True, 549),
        ("0056920503413","lob-1035", 599,"each",False,None),
        ("0056920503413","wmt-3124", 579,"each",False,None),
        ("0056920503413","wmt-3211", 579,"each",False,None),
        ("0056920503413","sob-2201", 669,"each",False,None),
        ("0056920503413","met-5501", 649,"each",False,None),

        # Lay's Chips
        ("0057000001217","lob-1012", 499,"each",False,None),
        ("0057000001217","lob-1035", 449,"each",True, 399),
        ("0057000001217","wmt-3124", 429,"each",False,None),
        ("0057000001217","wmt-3211", 429,"each",False,None),
        ("0057000001217","sob-2201", 499,"each",False,None),
        ("0057000001217","met-5501", 479,"each",False,None),

        # PC Cola 2L
        ("0062639015016","lob-1012", 189,"each",False,None),
        ("0062639015016","lob-1035", 179,"each",False,None),
        ("0062639015016","lob-1089", 179,"each",False,None),

        # Eggs 12pk
        ("0068826716011","lob-1012", 599,"each",False,None),
        ("0068826716011","lob-1035", 549,"each",False,None),
        ("0068826716011","wmt-3124", 529,"each",False,None),
        ("0068826716011","wmt-3211", 529,"each",False,None),
        ("0068826716011","sob-2201", 609,"each",True, 579),
        ("0068826716011","sob-2318", 569,"each",False,None),
        ("0068826716011","met-5501", 589,"each",False,None),

        # Hellmann's Mayo
        ("0073735900116","lob-1012", 899,"each",False,None),
        ("0073735900116","wmt-3124", 849,"each",False,None),
        ("0073735900116","sob-2201", 929,"each",True, 849),
        ("0073735900116","met-5501", 899,"each",False,None),

        # Kraft PB
        ("0055825501318","lob-1012", 899,"each",True, 799),
        ("0055825501318","lob-1035", 849,"each",False,None),
        ("0055825501318","wmt-3124", 829,"each",False,None),
        ("0055825501318","wmt-3211", 829,"each",False,None),
        ("0055825501318","sob-2201", 919,"each",False,None),
        ("0055825501318","met-5501", 889,"each",False,None),

        # Barilla Spaghetti
        ("0078742018812","lob-1012", 349,"each",False,None),
        ("0078742018812","lob-1035", 319,"each",False,None),
        ("0078742018812","wmt-3124", 299,"each",False,None),
        ("0078742018812","wmt-3211", 299,"each",False,None),
        ("0078742018812","sob-2201", 359,"each",True, 299),
        ("0078742018812","met-5501", 349,"each",False,None),

        # Tropicana Apple Juice 1.75L
        ("0069000007629","lob-1012", 729,"each",False,None),
        ("0069000007629","lob-1035", 679,"each",True, 629),
        ("0069000007629","lob-1089", 729,"each",False,None),
        ("0069000007629","wmt-3124", 669,"each",False,None),
        ("0069000007629","wmt-3211", 669,"each",False,None),
        ("0069000007629","sob-2201", 749,"each",False,None),
        ("0069000007629","sob-2318", 709,"each",False,None),
        ("0069000007629","met-5501", 759,"each",False,None),

        # Minute Maid Apple Juice 1.89L
        ("0055742410912","lob-1012", 699,"each",False,None),
        ("0055742410912","lob-1035", 649,"each",False,None),
        ("0055742410912","wmt-3124", 639,"each",False,None),
        ("0055742410912","wmt-3211", 639,"each",False,None),
        ("0055742410912","sob-2201", 719,"each",True, 679),
        ("0055742410912","met-5501", 729,"each",False,None),

        # No Name Apple Juice 1L
        ("0064777030061","lob-1012", 299,"each",False,None),
        ("0064777030061","lob-1035", 279,"each",False,None),
        ("0064777030061","lob-1089", 279,"each",False,None),
        ("0064777030061","wmt-3124", 269,"each",False,None),
        ("0064777030061","wmt-3211", 269,"each",False,None),
        ("0064777030061","sob-2318", 289,"each",False,None),
        ("0064777030061","met-5501", 299,"each",False,None),

        # Tropicana Grape Juice 1.75L
        ("0055742411919","lob-1012", 749,"each",False,None),
        ("0055742411919","wmt-3124", 689,"each",False,None),
        ("0055742411919","sob-2201", 769,"each",False,None),
        ("0055742411919","met-5501", 759,"each",False,None),

        # Nestea Iced Tea
        ("0067553033022","lob-1012", 349,"each",False,None),
        ("0067553033022","lob-1035", 319,"each",True, 299),
        ("0067553033022","wmt-3124", 299,"each",False,None),
        ("0067553033022","wmt-3211", 299,"each",False,None),
        ("0067553033022","sob-2201", 359,"each",False,None),
        ("0067553033022","met-5501", 349,"each",False,None),

        # Minute Maid Orange Juice 2.63L
        ("0069000018892","lob-1012", 899,"each",False,None),
        ("0069000018892","lob-1035", 849,"each",False,None),
        ("0069000018892","wmt-3124", 829,"each",False,None),
        ("0069000018892","wmt-3211", 829,"each",False,None),
        ("0069000018892","sob-2201", 919,"each",True, 869),
        ("0069000018892","met-5501", 899,"each",False,None),

        # Natrel Whole Milk 4L
        ("0058176410102","lob-1012", 729,"each",False,None),
        ("0058176410102","lob-1035", 679,"each",False,None),
        ("0058176410102","wmt-3124", 659,"each",False,None),
        ("0058176410102","wmt-3211", 659,"each",False,None),
        ("0058176410102","sob-2201", 739,"each",False,None),
        ("0058176410102","met-5501", 719,"each",False,None),

        # No Name Skim Milk 4L
        ("0064777040015","lob-1012", 599,"each",False,None),
        ("0064777040015","lob-1035", 569,"each",False,None),
        ("0064777040015","lob-1089", 569,"each",False,None),
        ("0064777040015","wmt-3124", 549,"each",False,None),
        ("0064777040015","wmt-3211", 549,"each",False,None),
        ("0064777040015","sob-2318", 579,"each",False,None),
        ("0064777040015","met-5501", 609,"each",False,None),

        # Silk Almond Milk
        ("0065684001038","lob-1012", 499,"each",True, 449),
        ("0065684001038","lob-1035", 469,"each",False,None),
        ("0065684001038","wmt-3124", 449,"each",False,None),
        ("0065684001038","wmt-3211", 449,"each",False,None),
        ("0065684001038","sob-2201", 519,"each",False,None),
        ("0065684001038","met-5501", 499,"each",False,None),

        # Silk Oat Milk
        ("0065684001069","lob-1012", 549,"each",False,None),
        ("0065684001069","lob-1035", 519,"each",False,None),
        ("0065684001069","wmt-3124", 499,"each",False,None),
        ("0065684001069","wmt-3211", 499,"each",False,None),
        ("0065684001069","sob-2201", 569,"each",True, 519),
        ("0065684001069","met-5501", 549,"each",False,None),

        # Balderson Cheddar 400g
        ("0069700050021","lob-1012", 899,"each",False,None),
        ("0069700050021","lob-1035", 849,"each",False,None),
        ("0069700050021","wmt-3124", 829,"each",False,None),
        ("0069700050021","wmt-3211", 829,"each",False,None),
        ("0069700050021","sob-2201", 929,"each",True, 879),
        ("0069700050021","met-5501", 899,"each",False,None),

        # No Name Marble Cheddar 800g
        ("0064777052018","lob-1012", 1199,"each",False,None),
        ("0064777052018","lob-1035", 1099,"each",False,None),
        ("0064777052018","lob-1089", 1099,"each",False,None),
        ("0064777052018","wmt-3124", 1079,"each",False,None),
        ("0064777052018","wmt-3211", 1079,"each",False,None),
        ("0064777052018","sob-2318", 1129,"each",False,None),
        ("0064777052018","met-5501", 1199,"each",False,None),

        # Kraft Mozzarella Shredded
        ("0072058210400","lob-1012", 699,"each",False,None),
        ("0072058210400","lob-1035", 649,"each",True, 599),
        ("0072058210400","wmt-3124", 629,"each",False,None),
        ("0072058210400","wmt-3211", 629,"each",False,None),
        ("0072058210400","sob-2201", 719,"each",False,None),
        ("0072058210400","met-5501", 699,"each",False,None),

        # Dempster's White Bread
        ("0064777005015","lob-1012", 449,"each",False,None),
        ("0064777005015","lob-1035", 419,"each",False,None),
        ("0064777005015","wmt-3124", 399,"each",False,None),
        ("0064777005015","wmt-3211", 399,"each",False,None),
        ("0064777005015","sob-2201", 459,"each",False,None),
        ("0064777005015","sob-2318", 419,"each",True, 389),
        ("0064777005015","met-5501", 449,"each",False,None),

        # Dempster's 12-Grain Bread
        ("0064777005176","lob-1012", 529,"each",False,None),
        ("0064777005176","lob-1035", 479,"each",False,None),
        ("0064777005176","wmt-3124", 459,"each",False,None),
        ("0064777005176","wmt-3211", 459,"each",False,None),
        ("0064777005176","sob-2201", 539,"each",True, 489),
        ("0064777005176","met-5501", 519,"each",False,None),

        # PC Multigrain English Muffins
        ("0060224012018","lob-1012", 399,"each",False,None),
        ("0060224012018","lob-1035", 369,"each",False,None),
        ("0060224012018","lob-1089", 369,"each",False,None),
        ("0060224012018","sob-2201", 419,"each",False,None),

        # Kellogg's Corn Flakes
        ("0038000596025","lob-1012", 599,"each",False,None),
        ("0038000596025","lob-1035", 549,"each",False,None),
        ("0038000596025","wmt-3124", 529,"each",False,None),
        ("0038000596025","wmt-3211", 529,"each",False,None),
        ("0038000596025","sob-2201", 619,"each",True, 549),
        ("0038000596025","met-5501", 599,"each",False,None),

        # Kellogg's Special K
        ("0038000045714","lob-1012", 649,"each",True, 549),
        ("0038000045714","lob-1035", 599,"each",False,None),
        ("0038000045714","wmt-3124", 579,"each",False,None),
        ("0038000045714","wmt-3211", 579,"each",False,None),
        ("0038000045714","sob-2201", 669,"each",False,None),
        ("0038000045714","met-5501", 649,"each",False,None),

        # No Name Quick Oats 2kg
        ("0064777058010","lob-1012", 599,"each",False,None),
        ("0064777058010","lob-1035", 549,"each",False,None),
        ("0064777058010","lob-1089", 549,"each",False,None),
        ("0064777058010","wmt-3124", 529,"each",False,None),
        ("0064777058010","wmt-3211", 529,"each",False,None),
        ("0064777058010","sob-2318", 569,"each",False,None),
        ("0064777058010","met-5501", 599,"each",False,None),

        # Doritos Nacho Cheese
        ("0028400064057","lob-1012", 499,"each",False,None),
        ("0028400064057","lob-1035", 449,"each",True, 399),
        ("0028400064057","wmt-3124", 429,"each",False,None),
        ("0028400064057","wmt-3211", 429,"each",False,None),
        ("0028400064057","sob-2201", 499,"each",False,None),
        ("0028400064057","met-5501", 479,"each",False,None),

        # No Name Apple Chips
        ("0064777025012","lob-1012", 349,"each",False,None),
        ("0064777025012","lob-1035", 319,"each",False,None),
        ("0064777025012","lob-1089", 319,"each",False,None),
        ("0064777025012","wmt-3124", 299,"each",False,None),
        ("0064777025012","wmt-3211", 299,"each",False,None),
        ("0064777025012","sob-2318", 329,"each",False,None),

        # Ritz Crackers
        ("0055826000171","lob-1012", 399,"each",False,None),
        ("0055826000171","lob-1035", 369,"each",False,None),
        ("0055826000171","wmt-3124", 349,"each",False,None),
        ("0055826000171","wmt-3211", 349,"each",False,None),
        ("0055826000171","sob-2201", 409,"each",True, 369),
        ("0055826000171","met-5501", 399,"each",False,None),

        # Compliments Ground Beef 1kg
        ("0068826001093","lob-1012",1299,"each",False,None),
        ("0068826001093","lob-1035",1199,"each",False,None),
        ("0068826001093","wmt-3124",1179,"each",False,None),
        ("0068826001093","wmt-3211",1179,"each",False,None),
        ("0068826001093","sob-2201",1329,"each",True,1199),
        ("0068826001093","sob-2318",1249,"each",False,None),
        ("0068826001093","met-5501",1299,"each",False,None),

        # Compliments Atlantic Salmon
        ("0068826001512","lob-1012",1199,"each",False,None),
        ("0068826001512","lob-1035",1099,"each",False,None),
        ("0068826001512","wmt-3124",1079,"each",False,None),
        ("0068826001512","wmt-3211",1079,"each",False,None),
        ("0068826001512","sob-2201",1249,"each",True,1149),
        ("0068826001512","met-5501",1199,"each",False,None),

        # PC Organic Broccoli
        ("0068826320015","lob-1012", 349,"each",False,None),
        ("0068826320015","lob-1089", 329,"each",False,None),
        ("0068826320015","wmt-3124", 319,"each",False,None),
        ("0068826320015","sob-2201", 369,"each",False,None),
        ("0068826320015","met-5501", 349,"each",False,None),

        # No Name Frozen Strawberries
        ("0064777090011","lob-1012", 499,"each",True, 429),
        ("0064777090011","lob-1035", 449,"each",False,None),
        ("0064777090011","lob-1089", 449,"each",False,None),
        ("0064777090011","wmt-3124", 429,"each",False,None),
        ("0064777090011","wmt-3211", 429,"each",False,None),
        ("0064777090011","sob-2318", 459,"each",False,None),
        ("0064777090011","met-5501", 489,"each",False,None),

        # No Name Frozen Mixed Veg
        ("0064777091018","lob-1012", 399,"each",False,None),
        ("0064777091018","lob-1035", 369,"each",False,None),
        ("0064777091018","wmt-3124", 349,"each",False,None),
        ("0064777091018","wmt-3211", 349,"each",False,None),
        ("0064777091018","sob-2201", 409,"each",False,None),
        ("0064777091018","met-5501", 399,"each",False,None),

        # Kraft Peanut Butter Crunchy
        ("0055825501325","lob-1012", 899,"each",True, 799),
        ("0055825501325","lob-1035", 849,"each",False,None),
        ("0055825501325","wmt-3124", 829,"each",False,None),
        ("0055825501325","wmt-3211", 829,"each",False,None),
        ("0055825501325","sob-2201", 919,"each",False,None),
        ("0055825501325","met-5501", 889,"each",False,None),

        # No Name Strawberry Jam
        ("0064777028013","lob-1012", 349,"each",False,None),
        ("0064777028013","lob-1035", 319,"each",False,None),
        ("0064777028013","lob-1089", 319,"each",False,None),
        ("0064777028013","wmt-3124", 299,"each",False,None),
        ("0064777028013","wmt-3211", 299,"each",False,None),
        ("0064777028013","sob-2318", 329,"each",False,None),
        ("0064777028013","met-5501", 349,"each",False,None),

        # Barilla Penne
        ("0078742015002","lob-1012", 349,"each",False,None),
        ("0078742015002","lob-1035", 319,"each",False,None),
        ("0078742015002","wmt-3124", 299,"each",False,None),
        ("0078742015002","wmt-3211", 299,"each",False,None),
        ("0078742015002","sob-2201", 359,"each",True, 299),
        ("0078742015002","met-5501", 349,"each",False,None),

        # No Name Sugar 2kg
        ("0064777006043","lob-1012", 399,"each",False,None),
        ("0064777006043","lob-1035", 369,"each",False,None),
        ("0064777006043","lob-1089", 369,"each",False,None),
        ("0064777006043","wmt-3124", 349,"each",False,None),
        ("0064777006043","wmt-3211", 349,"each",False,None),
        ("0064777006043","sob-2318", 379,"each",False,None),
        ("0064777006043","met-5501", 399,"each",False,None),

        # Folgers Coffee
        ("0025500072404","lob-1012",1199,"each",False,None),
        ("0025500072404","lob-1035",1099,"each",True, 999),
        ("0025500072404","wmt-3124",1079,"each",False,None),
        ("0025500072404","wmt-3211",1079,"each",False,None),
        ("0025500072404","sob-2201",1249,"each",False,None),
        ("0025500072404","met-5501",1199,"each",False,None),

        # Nabob Coffee
        ("0065633481017","lob-1012", 899,"each",False,None),
        ("0065633481017","lob-1035", 849,"each",False,None),
        ("0065633481017","wmt-3124", 829,"each",False,None),
        ("0065633481017","wmt-3211", 829,"each",False,None),
        ("0065633481017","sob-2201", 919,"each",True, 849),
        ("0065633481017","met-5501", 899,"each",False,None),

        # No Name Tea 72pk
        ("0064777073015","lob-1012", 499,"each",False,None),
        ("0064777073015","lob-1035", 469,"each",False,None),
        ("0064777073015","lob-1089", 469,"each",False,None),
        ("0064777073015","wmt-3124", 449,"each",False,None),
        ("0064777073015","wmt-3211", 449,"each",False,None),
        ("0064777073015","sob-2318", 479,"each",False,None),
        ("0064777073015","met-5501", 499,"each",False,None),

        # No Name Diced Tomatoes
        ("0064777043016","lob-1012", 149,"each",False,None),
        ("0064777043016","lob-1035", 129,"each",False,None),
        ("0064777043016","lob-1089", 129,"each",False,None),
        ("0064777043016","wmt-3124", 119,"each",False,None),
        ("0064777043016","wmt-3211", 119,"each",False,None),
        ("0064777043016","sob-2318", 139,"each",False,None),
        ("0064777043016","met-5501", 149,"each",False,None),

        # Heinz Tomato Soup
        ("0065633200018","lob-1012", 179,"each",False,None),
        ("0065633200018","lob-1035", 159,"each",False,None),
        ("0065633200018","wmt-3124", 149,"each",False,None),
        ("0065633200018","wmt-3211", 149,"each",False,None),
        ("0065633200018","sob-2201", 189,"each",True, 159),
        ("0065633200018","met-5501", 179,"each",False,None),

        # No Name Chickpeas
        ("0064777044013","lob-1012", 129,"each",False,None),
        ("0064777044013","lob-1035", 109,"each",False,None),
        ("0064777044013","lob-1089", 109,"each",False,None),
        ("0064777044013","wmt-3124",  99,"each",False,None),
        ("0064777044013","wmt-3211",  99,"each",False,None),
        ("0064777044013","sob-2318", 119,"each",False,None),
        ("0064777044013","met-5501", 129,"each",False,None),

        # No Name Kidney Beans
        ("0064777045010","lob-1012", 129,"each",False,None),
        ("0064777045010","lob-1035", 109,"each",False,None),
        ("0064777045010","wmt-3124",  99,"each",False,None),
        ("0064777045010","wmt-3211",  99,"each",False,None),
        ("0064777045010","sob-2318", 119,"each",False,None),
        ("0064777045010","met-5501", 129,"each",False,None),

        # Tide Pods
        ("0037000941774","lob-1012",1799,"each",False,None),
        ("0037000941774","lob-1035",1649,"each",True,1499),
        ("0037000941774","wmt-3124",1629,"each",False,None),
        ("0037000941774","wmt-3211",1629,"each",False,None),
        ("0037000941774","sob-2201",1849,"each",False,None),
        ("0037000941774","met-5501",1799,"each",False,None),

        # Compliments Paper Towels
        ("0068826420013","lob-1012", 899,"each",False,None),
        ("0068826420013","lob-1035", 829,"each",False,None),
        ("0068826420013","lob-1089", 829,"each",False,None),
        ("0068826420013","wmt-3124", 799,"each",False,None),
        ("0068826420013","wmt-3211", 799,"each",False,None),
        ("0068826420013","sob-2318", 849,"each",False,None),
        ("0068826420013","met-5501", 899,"each",False,None),

        # Compliments Bath Tissue
        ("0068826430012","lob-1012", 999,"each",False,None),
        ("0068826430012","lob-1035", 929,"each",False,None),
        ("0068826430012","lob-1089", 929,"each",False,None),
        ("0068826430012","wmt-3124", 899,"each",False,None),
        ("0068826430012","wmt-3211", 899,"each",False,None),
        ("0068826430012","sob-2318", 949,"each",False,None),
        ("0068826430012","met-5501", 999,"each",False,None),

        # Gala Apples 3lb
        ("0033383003039","lob-1012", 499,"bag",False,None),
        ("0033383003039","lob-1035", 449,"bag",True, 399),
        ("0033383003039","lob-1089", 499,"bag",False,None),
        ("0033383003039","wmt-3124", 429,"bag",False,None),
        ("0033383003039","wmt-3211", 429,"bag",False,None),
        ("0033383003039","sob-2201", 519,"bag",False,None),
        ("0033383003039","sob-2318", 479,"bag",False,None),
        ("0033383003039","met-5501", 509,"bag",False,None),

        # Granny Smith Apples 3lb
        ("0033383003046","lob-1012", 529,"bag",False,None),
        ("0033383003046","lob-1035", 479,"bag",False,None),
        ("0033383003046","lob-1089", 529,"bag",False,None),
        ("0033383003046","wmt-3124", 459,"bag",False,None),
        ("0033383003046","wmt-3211", 459,"bag",False,None),
        ("0033383003046","sob-2201", 549,"bag",True, 499),
        ("0033383003046","sob-2318", 499,"bag",False,None),
        ("0033383003046","met-5501", 529,"bag",False,None),

        # Fuji Apples 3lb
        ("0033383003053","lob-1012", 549,"bag",True, 499),
        ("0033383003053","lob-1035", 499,"bag",False,None),
        ("0033383003053","lob-1089", 549,"bag",False,None),
        ("0033383003053","wmt-3124", 479,"bag",False,None),
        ("0033383003053","wmt-3211", 479,"bag",False,None),
        ("0033383003053","sob-2201", 569,"bag",False,None),
        ("0033383003053","met-5501", 549,"bag",False,None),

        # Honeycrisp Apples 3lb
        ("0033383003060","lob-1012", 699,"bag",False,None),
        ("0033383003060","lob-1035", 649,"bag",False,None),
        ("0033383003060","lob-1089", 699,"bag",False,None),
        ("0033383003060","wmt-3124", 629,"bag",False,None),
        ("0033383003060","wmt-3211", 629,"bag",False,None),
        ("0033383003060","sob-2201", 719,"bag",True, 649),
        ("0033383003060","sob-2318", 669,"bag",False,None),
        ("0033383003060","met-5501", 699,"bag",False,None),

        # PC Organics Gala Apples 2lb
        ("0060224700032","lob-1012", 549,"bag",False,None),
        ("0060224700032","lob-1035", 499,"bag",False,None),
        ("0060224700032","lob-1089", 499,"bag",False,None),

        # Bananas 3lb
        ("0033383005019","lob-1012", 199,"bag",False,None),
        ("0033383005019","lob-1035", 179,"bag",False,None),
        ("0033383005019","lob-1089", 179,"bag",False,None),
        ("0033383005019","wmt-3124", 169,"bag",False,None),
        ("0033383005019","wmt-3211", 169,"bag",False,None),
        ("0033383005019","sob-2201", 209,"bag",False,None),
        ("0033383005019","sob-2318", 189,"bag",False,None),
        ("0033383005019","met-5501", 199,"bag",False,None),

        # Navel Oranges 4lb
        ("0033383006019","lob-1012", 499,"bag",False,None),
        ("0033383006019","lob-1035", 449,"bag",False,None),
        ("0033383006019","lob-1089", 449,"bag",False,None),
        ("0033383006019","wmt-3124", 429,"bag",False,None),
        ("0033383006019","wmt-3211", 429,"bag",True, 399),
        ("0033383006019","sob-2201", 519,"bag",False,None),
        ("0033383006019","met-5501", 499,"bag",False,None),

        # Russet Potatoes 10lb
        ("0033383007016","lob-1012", 599,"bag",False,None),
        ("0033383007016","lob-1035", 549,"bag",False,None),
        ("0033383007016","lob-1089", 549,"bag",False,None),
        ("0033383007016","wmt-3124", 529,"bag",False,None),
        ("0033383007016","wmt-3211", 529,"bag",False,None),
        ("0033383007016","sob-2201", 619,"bag",True, 549),
        ("0033383007016","sob-2318", 569,"bag",False,None),
        ("0033383007016","met-5501", 599,"bag",False,None),

        # Yellow Onions 3lb
        ("0033383008013","lob-1012", 299,"bag",False,None),
        ("0033383008013","lob-1035", 269,"bag",False,None),
        ("0033383008013","lob-1089", 269,"bag",False,None),
        ("0033383008013","wmt-3124", 249,"bag",False,None),
        ("0033383008013","wmt-3211", 249,"bag",False,None),
        ("0033383008013","sob-2318", 279,"bag",False,None),
        ("0033383008013","met-5501", 299,"bag",False,None),

        # Roma Tomatoes 1lb
        ("0033383009010","lob-1012", 299,"lb",False,None),
        ("0033383009010","lob-1035", 269,"lb",False,None),
        ("0033383009010","lob-1089", 269,"lb",False,None),
        ("0033383009010","wmt-3124", 249,"lb",False,None),
        ("0033383009010","wmt-3211", 249,"lb",False,None),
        ("0033383009010","sob-2201", 319,"lb",True, 279),
        ("0033383009010","met-5501", 299,"lb",False,None),

        # Seedless Red Grapes 2lb
        ("0033383010019","lob-1012", 499,"bag",False,None),
        ("0033383010019","lob-1035", 449,"bag",True, 399),
        ("0033383010019","lob-1089", 499,"bag",False,None),
        ("0033383010019","wmt-3124", 429,"bag",False,None),
        ("0033383010019","wmt-3211", 429,"bag",False,None),
        ("0033383010019","sob-2201", 519,"bag",False,None),
        ("0033383010019","met-5501", 499,"bag",False,None),

        # Strawberries 1lb
        ("0033383011016","lob-1012", 399,"each",False,None),
        ("0033383011016","lob-1035", 349,"each",True, 299),
        ("0033383011016","lob-1089", 399,"each",False,None),
        ("0033383011016","wmt-3124", 329,"each",False,None),
        ("0033383011016","wmt-3211", 329,"each",False,None),
        ("0033383011016","sob-2201", 419,"each",False,None),
        ("0033383011016","sob-2318", 369,"each",False,None),
        ("0033383011016","met-5501", 399,"each",False,None),
    ]

    now = datetime.now(timezone.utc).isoformat()

    async with AsyncSessionLocal() as db:
        from sqlalchemy import select
        # Insert stores
        for s in stores_data:
            result = await db.execute(select(Store).where(Store.store_id == s["store_id"]))
            existing = result.scalar_one_or_none()
            if not existing:
                db.add(Store(id=str(uuid.uuid4()), **s))
        await db.commit()
        print(f"Inserted {len(stores_data)} stores.")

        # Insert products
        product_id_map = {}
        for p in products_data:
            result = await db.execute(select(Product).where(Product.upc == p["upc"]))
            existing = result.scalar_one_or_none()
            if not existing:
                obj = Product(id=str(uuid.uuid4()), **p)
                db.add(obj)
                await db.flush()
                product_id_map[p["upc"]] = obj.id
            else:
                product_id_map[p["upc"]] = existing.id
        await db.commit()
        print(f"Inserted {len(products_data)} products.")

        # Get store DB ids
        result = await db.execute(select(Store))
        store_map = {s.store_id: s.id for s in result.scalars().all()}

        # Insert prices
        inserted = 0
        for upc, store_sid, price, unit, on_sale, sale in prices_data:
            product_db_id = product_id_map.get(upc)
            store_db_id   = store_map.get(store_sid)
            if not product_db_id or not store_db_id:
                continue
            result = await db.execute(
                select(Price).where(Price.product_id == product_db_id, Price.store_id == store_db_id)
            )
            if not result.scalar_one_or_none():
                db.add(Price(
                    id=str(uuid.uuid4()),
                    product_id=product_db_id,
                    store_id=store_db_id,
                    price_cents=price,
                    unit=unit,
                    on_sale=on_sale,
                    sale_price_cents=sale,
                    scraped_at=datetime.now(timezone.utc),
                ))
                inserted += 1
        await db.commit()
        print(f"Inserted {inserted} prices.")

    print("\nDemo data ready! Test it:")
    print("  GET http://localhost:8000/products/search?q=milk")
    print("  GET http://localhost:8000/prices/0058176510208?lat=43.65&lng=-79.38")
    print("  GET http://localhost:8000/stores/nearby?lat=43.65&lng=-79.38")

if __name__ == "__main__":
    asyncio.run(main())
