#pragma once
#include <QAbstractListModel>
#include <vector>
#include <QVariant>

class GameBoard : public QAbstractListModel {
Q_OBJECT
Q_PROPERTY(int dimension READ dimension CONSTANT)
Q_PROPERTY(int hiddenElement READ boardSize CONSTANT)
public:
    struct Tile {
        int value{};
        Tile& operator=(const int val) {
            value = val;
            return *this;
        }
        bool operator==(const int other) {
            return other == value;
        }
    };

    using Position = std::pair<int, int>;
    static constexpr int defaultPuzzleDimension {4};

    GameBoard(const int boardDimension = defaultPuzzleDimension, QObject* parent = nullptr);

    virtual int rowCount(const QModelIndex& parent = QModelIndex{}) const override;
    virtual QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    int dimension() const;
    int boardSize() const;
    int movements() const;
    void setMovements(int n);
    Position getRowCol(int index) const;
    Q_INVOKABLE bool move(int index);
    Q_INVOKABLE void shuffle();

signals:
    void finished(int n);
    void movementsChanged(int n);

private:
    std::vector<Tile> m_rawBoard;
    const int m_dimension;
    const int m_boardSize;
    int m_movements;

    bool isPositionValid(const int pos) const;
    bool isBoardValid() const;
    bool isRightOrder() const;
};

