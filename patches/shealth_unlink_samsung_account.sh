find . -type f -name "*.xml" -exec sed -i 's/com\.osp\.app\.signin/com.notsamsung.dummy/g' "{}" \;
find . -type f -name "*.smali" -exec sed -i 's/com\.osp\.app\.signin/com.notsamsung.dummy/g' "{}" \;
