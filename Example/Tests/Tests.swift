import XCTest
import UICollectionUpdates

final class Tests: XCTestCase {
    
    private var container: UIView!
    private var collectionView: TestCollection!
    private var dataSource: DataSource!
    
    override func setUp() {
        super.setUp()
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 20, height: 20)
        collectionView = TestCollection(frame: CGRect(x: 0, y: 0, width: 300, height: 300),
                                        collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        dataSource = DataSource(sections: 0, items: [:])
        collectionView.dataSource = dataSource
        container.addSubview(collectionView)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmptyReload() {
        let updates = UICollectionUpdates()
        do {
            try collectionView.perform(updates: updates)
        } catch {
            XCTFail(error.localizedDescription)
        }
        XCTAssertFalse(collectionView.isReloadDataCalled)
        XCTAssertFalse(collectionView.isBatchUpdateCalled)
    }
    
    func testInsertSection() {
        setDataSource(sections: 1, items: [0:1], reload: true)
        let updates = UICollectionUpdates(insertSections: [1])
        setDataSource(sections: 2, items: [0:1, 1:2], reload: false)
        
        do {
            try collectionView.perform(updates: updates)
        } catch {
            XCTFail(error.localizedDescription)
        }
        XCTAssertFalse(collectionView.isReloadDataCalled)
        XCTAssertTrue(collectionView.isBatchUpdateCalled)
        
        XCTAssertEqual(collectionView.numberOfSections, 2)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 1), 2)
    }
    
    func testDeleteSection() {
        setDataSource(sections: 1, items: [0:1], reload: true)
        let updates = UICollectionUpdates(deleteSections: [0])
        setDataSource(sections: 0, items: [:], reload: false)
        
        do {
            try collectionView.perform(updates: updates)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertEqual(collectionView.numberOfSections, 0)
    }
    
    func testReloadSection() {
        setDataSource(sections: 2, items: [0:1, 1:2], reload: true)
        let updates = UICollectionUpdates(reloadSections: [0])
        setDataSource(sections: 2, items: [0:4, 1:2], reload: false)
        
        do {
            try collectionView.perform(updates: updates)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertEqual(collectionView.numberOfSections, 2)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 4)
    }
    
    func testDeleteAndInsertSection() {
        setDataSource(sections: 2, items: [0:1, 1:2], reload: true)
        let updates = UICollectionUpdates(deleteSections: [1], insertSections: [1, 2])
        setDataSource(sections: 3, items: [0:1, 1:3, 2:4], reload: false)
        
        do {
            try collectionView.perform(updates: updates)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertEqual(collectionView.numberOfSections, 3)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 1), 3)
    }
    
    func testInsertItems() {
        setDataSource(sections: 2, items: [0:1, 1:2], reload: true)
        let updates = UICollectionUpdates(insertIndexPaths: [IndexPath(item: 2, section: 1)])
        setDataSource(sections: 2, items: [0:1, 1:3], reload: false)
        
        do {
            try collectionView.perform(updates: updates)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertEqual(collectionView.numberOfSections, 2)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 1), 3)
    }
    
    func testDeleteItems() {
        setDataSource(sections: 2, items: [0:1, 1:2], reload: true)
        let updates = UICollectionUpdates(deleteIndexPaths: [IndexPath(item: 1, section: 1), IndexPath(item: 0, section: 1)])
        setDataSource(sections: 2, items: [0:1, 1:0], reload: false)
        
        do {
            try collectionView.perform(updates: updates)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertEqual(collectionView.numberOfSections, 2)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 1), 0)
    }
    
    func testReloadItems() {
        setDataSource(sections: 2, items: [0:1, 1:2], reload: true)
        let updates = UICollectionUpdates(reloadIndexPaths: [IndexPath(item: 1, section: 1)])
        setDataSource(sections: 2, items: [0:1, 1:2], reload: false)
        
        do {
            try collectionView.perform(updates: updates)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertEqual(collectionView.numberOfSections, 2)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 1), 2)
    }
    
    func testInconsistenceInsert() {
        setDataSource(sections: 2, items: [0:1, 1:2], reload: true)
        let updates = UICollectionUpdates(insertIndexPaths: [IndexPath(item: 2, section: 1)])
        setDataSource(sections: 2, items: [0:1, 1:2], reload: false)
        
        do {
            try collectionView.perform(updates: updates)
            XCTFail("should be error")
        } catch {
            
        }
        
        XCTAssertEqual(collectionView.numberOfSections, 2)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 1), 2)
    }
    
    func testInconsistenceReload() {
        setDataSource(sections: 2, items: [0:1, 1:2], reload: true)
        let updates = UICollectionUpdates(deleteIndexPaths: [IndexPath(item: 2, section: 2)])
        setDataSource(sections: 2, items: [0:1, 1:2], reload: false)
        
        collectionView.performOrReload(updates: updates)
        
        XCTAssertTrue(collectionView.isReloadDataCalled)
        XCTAssertEqual(collectionView.numberOfSections, 2)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 1), 2)
    }
    
    // MARK: - private
    
    private func setDataSource(sections: Int, items: [Int: Int], reload: Bool) {
        dataSource.sections = sections
        dataSource.items = items
        if reload {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            collectionView.isReloadDataCalled = false
        }
    }
    
}

private final class TestCollection: UICollectionView {
    
    var isReloadDataCalled = false
    var isBatchUpdateCalled = false
    
    override func reloadData() {
        isReloadDataCalled = true
        super.reloadData()
    }
    
    override func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        isBatchUpdateCalled = true
        super.performBatchUpdates(updates, completion: completion)
    }
    
}

private final class DataSource: NSObject, UICollectionViewDataSource {
    var sections: Int
    var items: [Int: Int]
    
    init(sections: Int, items: [Int: Int]) {
        self.sections = sections
        self.items = items
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section] ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
    }
    
}
