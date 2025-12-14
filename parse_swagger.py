import json

with open('swagger.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Extract BulkUpdate DTOs
schemas = data['components']['schemas']

print("=== BulkUpdatePermissionSortOrderDto ===")
print(json.dumps(schemas.get('BulkUpdatePermissionSortOrderDto', {}), indent=2, ensure_ascii=False))

print("\n=== PermissionSortOrderItem ===")
print(json.dumps(schemas.get('PermissionSortOrderItem', {}), indent=2, ensure_ascii=False))

print("\n=== BulkUpdateRoleSortOrderDto ===")
print(json.dumps(schemas.get('BulkUpdateRoleSortOrderDto', {}), indent=2, ensure_ascii=False))

print("\n=== RoleSortOrderItem ===")
print(json.dumps(schemas.get('RoleSortOrderItem', {}), indent=2, ensure_ascii=False))
